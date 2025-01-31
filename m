Return-Path: <io-uring+bounces-6203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED04FA241BA
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 18:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFAC03A37A9
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3966D1B85F6;
	Fri, 31 Jan 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Vt4jj7fU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C00F53368
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738343795; cv=none; b=fI1IxzbWxS2QHQk6oHUPxAHw66JauianYm5HgMpQb+w+7vBU1Lpn/O+oT67ft0oBorR3JFLBR8mb+Jb2jH5IuBW9oncQCzcbfi0ZuOW6HU9p0en1fIly9+U4z5wMQAFo9vTbwuGvCIE/FCF0v0lhGh8Hd3MV0vgIlf2AoVEmU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738343795; c=relaxed/simple;
	bh=IJpXKd7iwRYoZffANHjuO9WmlQvJWizra56J/pdegfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lb4+df8KP/uitF3a+B7zj/RsIdf3BDjJ0NZu2mBx0Db6aT/c1XEmciWMXnZW8MDmBNb9KKckLT8f9UESf/aObIVGv93kvuZLoasmSANEoTETqs3n1S7NGEJFeutP0HQSCjAhWGnT+kTVAwzUebbWApzx8lLdB7G5p9t+DSy/NNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Vt4jj7fU; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso480339366b.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 09:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738343791; x=1738948591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqSRqdRuMVUS0hR3bXfCSvdzWeHIS96mx4dwh5De168=;
        b=Vt4jj7fUBJFyOLCUAOxOfXiwNgXuFY6Q0+0QTv81LcG8cTFIqNrdA3c1ZrI2WUjgYC
         hgipZhXShaTH9CzqvPAOlko6JWk3hdwWhJuPSDgQ82X0XVB+dQAV/yGaxF5PTSszLoZb
         gZW8e2Nd3To8gCqeaRHdoXBwmelP7wj7rPYnAZc+SJIl3H6o5TCVfh5YACEohsO3mWX2
         665MBzMXP6VStOKIIQO/zR1bSm3N8h+pMgKDQYpbtNrBkxKfwzBx7uXec8c0e9FKTS3Q
         r2umxkGhv0kTE61CmmqKmzJKcbAFpa0FWPBRcpVxehhjwOC3gcFGQFO+Ljixn9e5i3L/
         UNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738343791; x=1738948591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqSRqdRuMVUS0hR3bXfCSvdzWeHIS96mx4dwh5De168=;
        b=dUGCr0C3ovZwW9KLP3LZ7r8htYeejB3MgEySFf6+Y+op4xKtHdnUtVksk5dgjLunqm
         uqQ8rmQsCfQyiqQquwf3QagfbiWFK45RqPXTVh5EaCmxfM+mLJfd2QB7hAlX2yqPE9r3
         lZk0aU8uHWUwujs6qaR0ij7oIhY02NkE+kr0KX+QPkocjMbFqpzxwv8dzacXBH8Nc+cF
         ViSjfGkYAa3KfapCAXConRewpyQ6RMWLgqn7bEo67ZZFCd+LhS7zNJZvmSidgy6BDLrh
         XrlkkqDJd2BAP7yayVJ31Q8hyAMFSFzyA9p6caXkxyF8gW7EriRUxTw06uIJSP7zR9GG
         bnUg==
X-Forwarded-Encrypted: i=1; AJvYcCXJIIb3K0Cu6NPxAMOmzprbqaTbiNjudfDBjVG7yVl5qk8OvHFQnAujjtJ7wpXPLhUEhESCxLYU+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YztyFRaiiv9roSZEoLSTwK8KwIlKvVi+RcbJWWLGenNy7sb76Ag
	lGjGP++egFC02jSWVddXDBH8Sg8y9If1318u3wmfOzNiIGXYxfApmR5lhXCyEd5kW6tT6bxS7T2
	WArvKM8zBCcyWf68n/SDg+hMFSZavsgrYFE/QpQ==
X-Gm-Gg: ASbGnctXGHKtmZziheACgtoXi98zZ8pJ3NcVKZEpj+MsMtfyS700u6ASeIEPRs7l+vo
	EK5+wLjQYWbUBfjw2uiJiUCJbphxOJPE6zTCEB5ixLqBOJIsp8V4wAgioNC8EujyckjhEJ8A/ex
	sincN/AR3E5ncbMTOYurpEa32ZQA==
X-Google-Smtp-Source: AGHT+IFrg/3LHjJ/lnlIA5OZd/lPJwrUoD7pnmT/wTf5Yed08bwxEvL1yRpJsQHHZdHQcPsit+hXF79AJUi6y8BFTXI=
X-Received: by 2002:a17:907:728c:b0:ab3:64dd:bc89 with SMTP id
 a640c23a62f3a-ab6cfce265fmr1329620366b.20.1738343790697; Fri, 31 Jan 2025
 09:16:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-9-max.kellermann@ionos.com> <794043b6-4008-448e-b241-1390aa91d2ab@gmail.com>
In-Reply-To: <794043b6-4008-448e-b241-1390aa91d2ab@gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 31 Jan 2025 18:16:19 +0100
X-Gm-Features: AWEUYZngMvc8L7CbnAKSWZY60DE5_wFqVJVZxAc2vuwSHc9kVxszNfA2g1obggI
Message-ID: <CAKPOu+-SYVHAWbLgrih338E_wCyOqEqA3cBHXf3qa-Xbx43hgg@mail.gmail.com>
Subject: Re: [PATCH 8/8] io_uring: skip redundant poll wakeups
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2025 at 2:54=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>                                  |     // it's still 0, wake up is lost

I think I misunderstood how these polling functions in the kernel work
- thanks for the explanation, Pavel. This one patch is indeed flawed,
and I'll try to come up with something better.

