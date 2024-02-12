Return-Path: <io-uring+bounces-594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3F08516B8
	for <lists+io-uring@lfdr.de>; Mon, 12 Feb 2024 15:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 624FB1F2508C
	for <lists+io-uring@lfdr.de>; Mon, 12 Feb 2024 14:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23E93A1C4;
	Mon, 12 Feb 2024 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7TYYfp5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0143A8F5
	for <io-uring@vger.kernel.org>; Mon, 12 Feb 2024 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707746840; cv=none; b=ls4nZiWgpmtwuo8OB2VbyjJTTT6aJAPmQA6TUuR3beh+TrGT6LCcmwFH2ERShjxwMSp7Ki07eE+GHf4a9Y+/UF0MKy4d54WspC0ispCweZNfNtVNQkeUKHHW3k6TwOgDJJn3+enhUp2YKlz604J9a0KtXmBXWgvPlBaOO/fv34s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707746840; c=relaxed/simple;
	bh=X75lLwzkhXfaAKeD9RVPUbK5SugflzA3FB+ADjwrXQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCubWD5GKdZq4RKX+QLBDwu9mweGYACJLJnFNB5N8aiZYq/E/roootmgs7ANDMKnJAw+ew5vfduTDNQ2+jBRIbL9DLhUKk4rOMyxIIL4aHFNVlOOxcsAVyzTZQyLHr4MlFOJWGodYoA9SUC/4XfY0gJZtKf20r6KVDGyEvIefjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h7TYYfp5; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6861538916cso18436276d6.3
        for <io-uring@vger.kernel.org>; Mon, 12 Feb 2024 06:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707746838; x=1708351638; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X75lLwzkhXfaAKeD9RVPUbK5SugflzA3FB+ADjwrXQs=;
        b=h7TYYfp5E/fTBL5VhVihBLSj0ev72vuRI0MaiSXwcjn8PsJSJ5xgFCJttpyKGYDAfs
         KV31knWaiRccn1dUwl0LZMKoqRr+w1fMzY4lbydcFcqU2ox8mQ3IxcFTFdcvKYFgWcHa
         9YuHu8+7bcmYuf5G3SGiRCfI2Qi5NarQf7Yr6t2seVm2t81G/y9RgGX6DlbLGP5/gbC8
         cyObJgQbYaQ4CZXcKeUih+P1qI7O/uNcTcTsh9nxR9Wki7x3Lx3SLjEBPoSA2Y0BLJzD
         H+42nFDpu6/ga4wE2cl7vKF3kp4NmZiKx/X709F/XA3MXg3vUiOnekHlBj5Nrd8slPZ3
         k11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707746838; x=1708351638;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X75lLwzkhXfaAKeD9RVPUbK5SugflzA3FB+ADjwrXQs=;
        b=KEDZAJwWtWTjHB2Mu6EZk3F6a+9KnqlMVdFVjc4HDVx2G16y2Y7xGiq/FtBXPcSz7Y
         yjeJj0vFNBUh/5kianXalSr0MYRK8z7qheSraTW7/TiFI0sK/6EreFCsG3PfhRJIMwpP
         XbuPaUaB6x0KMbwuuJsfbhHRboLgLP1gU0gxgFaGbf6qKg8EDv1AlnzrZS9TioNzunzV
         gg1Rs5lpNTyljSVrIuSnyf9O17np1DmZP9lnQjy7uP326xAAuEvRVBFsHDh7lAF7/QXI
         g6QxWqrsz/Lc58nzNAuQ2wRsnop9aFJ0DpeQ1kVDTuVD9pfcTjuzvbYOoRMpUKPPnzGS
         TLEw==
X-Gm-Message-State: AOJu0Yyn916R2ibL6Y3VNlVte4BVNsDV0fTYk3MKk9miId0zsKNRVYML
	u2Rct2tcNCLWQ/FVXwD0RXvdqyW50dBW8QxzVsDGtAZNEeHrGloR1IjvBxR/9to6+ICQVAzsNz3
	5CptXbRFpWbtU2nbdie7ib5Y211MkmkWMsVQO
X-Google-Smtp-Source: AGHT+IGjwPhN6JqVQ82AFNLhiMQTIuzrYEzVitUlSMWygLKcCDX+757lakc71GgIQDPB7QuK/lI1ZJQD6dQcrwSYUxQ=
X-Received: by 2002:a0c:ca81:0:b0:68c:9621:af26 with SMTP id
 a1-20020a0cca81000000b0068c9621af26mr8077667qvk.15.1707746837886; Mon, 12 Feb
 2024 06:07:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000004b1fa70610fa3230@google.com> <f7a6623d-b55f-4301-be1d-ee0327ebd353@kernel.dk>
In-Reply-To: <f7a6623d-b55f-4301-be1d-ee0327ebd353@kernel.dk>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 12 Feb 2024 15:06:41 +0100
Message-ID: <CAG_fn=VEEWnqbGUBFXgaTPYpP_E5QHxXtiqaDnuwkNHFzik0Yg@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_rw_fail (2)
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+0198afa90d8c29ef9557@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> This was fixed a while back, not sure why an old kernel is being tested. But
> in any case, the result of this was just garbage in cqe->res for a request
> that was prematurely errored. Nothing to worry about. In any case:

Unfortunately KMSAN is broken at head, we're waiting for
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=558c04d9535d9d8911162db4d0d758f8f4cda37b
to reach mainline.

