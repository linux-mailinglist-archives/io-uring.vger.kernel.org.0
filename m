Return-Path: <io-uring+bounces-9673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82095B500BE
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0BE01C6259B
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6EC34DCFC;
	Tue,  9 Sep 2025 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a0r+SLzK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F6345740
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757430819; cv=none; b=G++nim8GVchANlHlUvo6nTINJtHUdx/0UDlOuxcHAWDijjm+KV7JEPpEoMhzAKyCttbNcBm374ClMPhpqvtxVj6n0hpbMMeb75Hd+Ltm4NEQk9capkRgSIJMRMtCq7kKZ6mf/f/ZX9rYvmCkF2202ZmcQldj4Ascf7U9mjQ/w/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757430819; c=relaxed/simple;
	bh=Ba0OhIjYTLMiU3oxACpeC2jlMILOb4FcyPfqCiUaRVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ach2Ni01M5osbrAcM12mZgkzoc6kjCyyBZkqP3OxomFzWnpo/nwiol8s3FLxD1y7QDKOOfy+ElzLviFUddI+pFoyegjmJm09KXttQXPHx8NOZDzNsW/1MsLe3NT//bRi2hz4Ra7/ghFSeA4VgONsmTyWgO+osJQS0o5xM3ZGezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a0r+SLzK; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f6f434c96so5507055e87.2
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 08:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757430815; x=1758035615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGh77ZpqmdGlBlK4akr3+AuuurmRl+8arU8n5sa2puE=;
        b=a0r+SLzKO4nLhffhhxISPeeOcYenjGwlRwTnNnN7/nsiq75oOC/HxvlWvhmjcMkJDC
         7DApqJVzNIwfnUYz/Hz28aAn85+3Mjrr8uykQ/OYj7enP+oXZPKDBAH0xjgSBeCpa1Iv
         VSGZivsfZbvkhWH/sv43h0n68RnoodaChBIgA5LP9aKK33bFJNCwdxkVzqV1D8CS9+79
         +n4sfo+4+BxO3uTOWs76Payxm8Jdv79krkGJVWlE/+C+DCKzWhzVVE7k9kOjtA5rnzyM
         pAEMDFE/yOiszEha+fjYHbjXvsVww2uN5QysgpDYVKcUEmDg9tnhcSAGhOYnqpNCslv6
         udzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430815; x=1758035615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGh77ZpqmdGlBlK4akr3+AuuurmRl+8arU8n5sa2puE=;
        b=izEGtM+6E+Aqw0HOwVqNTDIc9RTT/MYNdY1dUwo7ZdanF2usm90WVNJNVEq/5KxvZD
         PfPdu0n+3YFe9Pqrtv0/pWdrTFQguzgqLiTjWZbED7/D+fX9RRneLH/O7QoU+ZL18BK5
         jYe0DUgDLi3XkJ9bhnAlfMb8ET0ClPKlSebyOKdhfmu9gl/TuICyFbeNoM6CB8Zk5KNC
         L34X00wDKipn6zx0k0pUJgRZu4gP3SvaX7usF8mmmXBeTTHROrnR1husk6D6FZnF3rqn
         YevYDLCLtktooL9G7JeUZ4gJraBVlfQZadxR6+j/jHo0bmBq8UhWbD9edX/Zc2/B5XWB
         F6rg==
X-Forwarded-Encrypted: i=1; AJvYcCWtszwlyNPs2+nNNOXda/+W07/XXZEpLi+lyXSA8k15Bw05IVMbyOC4cYKk8b1bZla3deNFJpjo6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzC3yiYVBF4Duvjzj2j0R/fzOLE/ZRblc9RT5SEabBTFIo1FOr9
	fLv0HWHaWmB1m4MnpuJv4ZqPVogYwCJLknSK5PtRGgbn5wix6KWBKRJfOi5BDdGHsoQDMn8f3Sl
	ErNNJDb5GuoxmbpWBe9lYC2NyDbpf/Plxm/bglH+rOg==
X-Gm-Gg: ASbGnct2jubgegtV+NGD7HdtdPXWw4zMUool4+XrBkRrvYYZgmgzSciFvetzgtN0k0y
	3yDZaP7ah8CU0LHRqkRNJp/Ca8foOnyCqgx5RSi8+dGHBovpW9u+Ets8EJMyhYdXjv9TjgTwFNJ
	BqCvkBqUu41OFcmxxOpqh6u7G+X1zZSSNiIz1FcOE8n6yqm+o8VsBEJJdwuY6Kb2QJojAEQQq3v
	ZQlp8P4J2CcMFk1pHQMx0a3fSIyb6IOnirer8c2Tm2l8m0eoGI=
X-Google-Smtp-Source: AGHT+IFSZyUfZN83V4CIF15pJ9WW73KK6A3AqmzdyuMeYCc1Xez+//dyjWNcpjNv9xi63JQzWXyoAh8tMA846TPE074=
X-Received: by 2002:a05:6512:2902:b0:55f:6d33:f37d with SMTP id
 2adb3069b0e04-562603a2906mr2874685e87.6.1757430815093; Tue, 09 Sep 2025
 08:13:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905090240.102790-1-marco.crivellari@suse.com> <175743072926.109608.13668500662715928702.b4-ty@kernel.dk>
In-Reply-To: <175743072926.109608.13668500662715928702.b4-ty@kernel.dk>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Tue, 9 Sep 2025 17:13:24 +0200
X-Gm-Features: Ac12FXyMadLYuOZrzk6-69qVQHbOFQB4QKKKuk42CzSO_NGvI6rDPCTY3mupUss
Message-ID: <CAAofZF5XsHsWSccR00bTut1A-wgNftMOZrwP9zqc=YQ=-rj68g@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 5:12=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Applied, thanks!
>
> [1/2] io_uring: replace use of system_wq with system_percpu_wq
>       commit: e92f5c03d32409c957864f9bc611872861f8157e
> [2/2] io_uring: replace use of system_unbound_wq with system_dfl_wq
>       commit: 59cfd1fa5a5b87969190c3178180d025ee9251a7
>

Many thanks!

--=20

Marco Crivellari

L3 Support Engineer, Technology & Product

marco.crivellari@suse.com

