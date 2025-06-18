Return-Path: <io-uring+bounces-8409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADFDADE428
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A99617AA82
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764A2277803;
	Wed, 18 Jun 2025 07:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OPp4O0WF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F611A23BB;
	Wed, 18 Jun 2025 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750230152; cv=none; b=McH3JUwCH5rwGfzhI6EZ0QbytKdg8Ka5GiOJjR4Ziv3UH6LASCvHjryFXlg0qiZ9iBpccKyhhxwb/u0A9szmOB/jLwFdcf0U1LqRyLySwCB6al7XnAl7rs5fE0QkXQUT+Q98jGnfYX+ajHHH+bKpUoWr8SjfYIhVMZD7Nmn45GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750230152; c=relaxed/simple;
	bh=AZ8eakkbu827EuhTE2TgSWfoJamjsmR+ZwSjs+5D78o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ulwvPjgw8SZDfkwp2ITv6v8w4q2HUi53r4AYLKD/kD37jpFPvVQJ4cnc1JCOQQcoL8CgjB381NX03IVkJq9cbve8zyGyVknjHswtlKLm2PjABpnCZRp85RQpEWkE71mpj5Ep7A2fLukkhh7+D9vWQwpJvygik41Hs80yrfU9jzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OPp4O0WF; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddd2710d14so60905185ab.2;
        Wed, 18 Jun 2025 00:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750230150; x=1750834950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZ8eakkbu827EuhTE2TgSWfoJamjsmR+ZwSjs+5D78o=;
        b=OPp4O0WFb3bZDzUH0gOHDHkeXt9XdietkJ18gt67e/IuHSs1KEdW2OPMAq54CcstFL
         WvgiPO/MC0gVGF0dNzMVazRsb+zbRGitwNb6PuTOrkjwsR8Tyi0IQ/qPJS+ldLoSJbzL
         Iaa6V0z7eKqVR69Q7m/q1CKEs67V9FZbgQC10t9UYjLMnbyzStJ6xWqVmcDtACpGRC0j
         VZ155G8jC9VLkZcy9z2eIDbAZEXE19onmjtgSAC5YPkeMJr+YLbhUUpu6GKC9eOgo68b
         sNSsT7Hf2/gOvuQYED7yPq5ELsuibu0RcNbOGwdctixADyCJtkaBh0hFezZvT/kqcA2K
         zfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750230150; x=1750834950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZ8eakkbu827EuhTE2TgSWfoJamjsmR+ZwSjs+5D78o=;
        b=qMAwZa1bf+OcHU1qZH4Ist11DOhL9THEJVkJgpk0MU+ljZilvulRF+cpEw/JbJ9BCX
         HdmMHsRJyoV0P99scxlScREnvaNSMbT9wlKaqL1qXf5Vv/czi94ltRLiXHXldei3iHhB
         u2kGjfjWvQFvwvs7FBXiFEaJ4ql69bwvBJ5ZP/sllCSZJQmm2jtgIFhL5jhjtXxc1PC3
         2nW2/e0fXLCDt8BLILdNSF9SA2cAnxyrKAO/qtjVMzu380YWlroQLS4ypTLSh3qtPlVo
         eSSAJwp+rbt7CT9SL4JzVH4c5HbXVeilfzTy/xxJLAuQnZCHZ73nVo5c3pPNm/TBZU4v
         LCaA==
X-Forwarded-Encrypted: i=1; AJvYcCVsTmhIW2vDp7Dwb8Hq8BJ3lON09EsubfIC2wuLIrL8z6wi00nUuynIAk91rnJ0Brs45rntxgs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHYoGPf/azMXe62aWANVIrDcMdntYnVxB8i65Vi3JHCy/15yhq
	5BWTRsAy2SqZ+Klv3kXXLaJUW0UGPv3RHE7YOZWvblCeP1sw1NUWguH7RvjTc1asACJUIr//3p3
	kT1JccCyE5uu1JIY1odXRHtmgk/zzt8I=
X-Gm-Gg: ASbGncsa6bn8Lx8jHqD6izbhvJ5WSdjkTAp+Y+RDlf0Uor9HLjASehmoUj9eyV9kgCf
	jEUCwuXLq31dkz0wDb3VvoEMMK2x0MPm/u7LQTebhEszEBxqkxFacc6cUSAh2uR8tHSWXPIeQD1
	thbBpPjCUAVMamTwa6zdAOh/Gchik2hrKEI9BBPdnlZDY=
X-Google-Smtp-Source: AGHT+IFagww3pxOoOKsEFeuXbX+NHva9IsyD9xZhOtoR8v7SpOOBVYkojySXKhuMk5XZSqETNSbTEv9mBPBVHaZh344=
X-Received: by 2002:a05:6e02:2482:b0:3dc:8058:ddfc with SMTP id
 e9e14a558f8ab-3de07cd045fmr165604885ab.11.1750230149937; Wed, 18 Jun 2025
 00:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1750065793.git.asml.silence@gmail.com> <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
In-Reply-To: <702357dd8936ef4c0d3864441e853bfe3224a677.1750065793.git.asml.silence@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 18 Jun 2025 15:01:51 +0800
X-Gm-Features: AX0GCFtI_6Syj--jN1osN8b3IwBnDhOc9cmGPDIfbz9j-qf3m5_nSa7qw0hJtXc
Message-ID: <CAL+tcoAeWk0MPw56NjrPBm3BOUmAMnSrw=wbbMUe3X92-wd4Mg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] net: timestamp: add helper returning skb's tx tstamp
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Richard Cochran <richardcochran@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 5:45=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an error queue skb.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks!

