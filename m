Return-Path: <io-uring+bounces-11222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 69463CCDA7D
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 22:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D72C9305AE20
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 21:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D58E330D22;
	Thu, 18 Dec 2025 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BrJDbduT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7402EA72A
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092517; cv=none; b=u6nfEmn1LJ5SdNmyL7in/jUPDNI7Wz7oMjT5BHwsq74IHeR/ygA7yfFPKGWqZX8mWkIWA+Y9uZ+fs7wtAp87A/hMGhgu87GW/z2KUs6sa67IWaO62PkNdApCxyj1I0OxfIWScYe8JNWbTjwlAUuYT+vH4h1Z4AIajPhSTE5nx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092517; c=relaxed/simple;
	bh=kDYBrODo75g8AhRSFpwd4cdqYkiEKhQgUsCdgrGWRTA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=VVyjUrYkLqswFxalURLvMbaBJgzCR3Yc3ivSN/aC0FfO9JfdzN/Pq8vqi5ccRBENPaHHm+aSDDUtpw9kNu3WAQIEI7g/uGbKDndQVIwO+I6BiOTLLa004vB09ChhIrQneQLokgkk8gPyYkPDwu5eZDLqp8uLjkCnW2r7f18PVl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrJDbduT; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-78c8d74bf4cso9339057b3.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 13:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766092510; x=1766697310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7EJNg3GNbNtFly+Dgb11Z3nvaLC93gGijDefaE9bOk=;
        b=BrJDbduTX2VuayZQDYyxkcPSSPoatdQznUi+FgfT56ngWtsP7UbWAJ98GVgd6c2BST
         HZQC0Mv99zVKNU0pkBo8BMjxOble/Klf8PVMbQ1NQ6kR/YVlP5VUKVueFRhEZgxsbOW2
         H8NjhW0vsx0ZJVxDcgdzVXmkSOe+56XfI6qcGVQATgEjl5noFc9aU1caIh/BKOCU5Mf9
         58qUEb/5pN5m7UOl2pKx0sX9WP2LzcetLxvS29F/4a0U3BOVnzuYj1BRVUNQaDRXRa4D
         gtMuzk6OSFyKtUNOU3RNmwzhExKREJO/oPacs3+k+mPGMmsbCwj1HRjLqyqYTKzImYfS
         FlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766092510; x=1766697310;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7EJNg3GNbNtFly+Dgb11Z3nvaLC93gGijDefaE9bOk=;
        b=P/FxZzj6yt4WgEAXY28emk3ppBUV2JT/KKgOLGir8Jgv/ajImVZmS92WWTkKWMj+2i
         iMsQzfFB5RUgFUYm5oxUA4hGDFaH2aDz4YIMLvRKNLLoU2TpoR6GzVZbC7mi0x3S1eyu
         JZ+nCXCkGtkq2CX/inIs+FCxf97gLGK7vHf3VwZPylAia7p+49hp6ZhHuWucc6nHhQUu
         rNnQLNtFcYFGBAMkB73VMheXCqX8dxSo9lfSNWPT8kbA8z2ikesHZBCtWT4GTpMLBMER
         TW2TTqY9oW4oIjJ54aNkFKKm/dZoeaGRixIdEZwu0Gsanl6x8B6qruKRs0ytRR0rwvMZ
         3j+w==
X-Gm-Message-State: AOJu0YzDFY31UnGUxakYplErFUAU8ea916LRnM2GDu92pjmYXryEnAzt
	8aAWK8kOjekT1J0aoffJ5b+w5n+2dQDE3kDmGj0eZXVuwiNhefJh6Xo5
X-Gm-Gg: AY/fxX7IsU/NQRvtawCACPefAnEBQzPPTT35W4u8HojiYryGfJPzJoapNrumWBk8niA
	8gMwScS1gxlfepQUrHoZ6XQ296qLcAAhtgbqFsvxQVQyUHfkvJ9Yoq5oUXveWE9vmMnZrrD5xph
	Wh5SE9WgTe4QJgIhJpTkLl2qQBRuZ82IZWpEJOZ2HaxmFKj8k/ZOk3xTa3mFPFZuibrdH+mOMit
	VG2zr+y74UvvYoaOvpmgdvHivIrpQ2mCeSgbD4HMdWQRWWJrG++VTvbX+WcjWFhl2fnPeazy1PD
	jbu23c42e3lCAR50R2t/ZpvXfYbGsR963fSKH3l+iyo4oBznNZ5l2dkyGgGAUmuGMwEz2LjkuQS
	Th0WBV9WDpb3E71PTYEZXjCV2Z08yCnnG6ZTpbsDPZcmSXY0vqZPS94Jpioic948+OVyYwDPPcF
	gDfPilczodiC7nuRoW2dfjt6S7e+g4wlA5gbPcyiMfs8pJWIjYPsM81ws5HBHJllLe7IY=
X-Google-Smtp-Source: AGHT+IG4ECQi8oDKhQxGm1qHPHPvrScfN7C5vMJkOguq9B4//xNoSJKvZk6KXg/e2kyUwtNjtUFDfA==
X-Received: by 2002:a05:690c:6288:b0:783:7867:eeb4 with SMTP id 00721157ae682-78fb4064e7cmr6281617b3.53.1766092510327;
        Thu, 18 Dec 2025 13:15:10 -0800 (PST)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-78fb416b32csm2312937b3.0.2025.12.18.13.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 13:15:09 -0800 (PST)
Date: Thu, 18 Dec 2025 16:15:09 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org, 
 kuba@kernel.org, 
 kuniyu@google.com, 
 willemb@google.com, 
 stable@vger.kernel.org, 
 Julian Orth <ju.orth@gmail.com>
Message-ID: <willemdebruijn.kernel.164466b751181@gmail.com>
In-Reply-To: <2ed38b2d-6f87-4878-b988-450cd95f8679@kernel.dk>
References: <20251218150114.250048-1-axboe@kernel.dk>
 <20251218150114.250048-2-axboe@kernel.dk>
 <willemdebruijn.kernel.2e22e5d8453bd@gmail.com>
 <2ed38b2d-6f87-4878-b988-450cd95f8679@kernel.dk>
Subject: Re: [PATCH 1/2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On 12/18/25 1:35 PM, Willem de Bruijn wrote:
> > Jens Axboe wrote:
> >> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but
> >> it posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
> >> incorrect, as ->msg_get_inq is just the caller asking for the remainder
> >> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
> >> original commit states that this is done to make sockets
> >> io_uring-friendly", but it's actually incorrect as io_uring doesn't
> >> use cmsg headers internally at all, and it's actively wrong as this
> >> means that cmsg's are always posted if someone does recvmsg via
> >> io_uring.
> >>
> >> Fix that up by only posting cmsg if u->recvmsg_inq is set.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
> >> Reported-by: Julian Orth <ju.orth@gmail.com>
> >> Link: https://github.com/axboe/liburing/issues/1509
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  net/unix/af_unix.c | 10 +++++++---
> >>  1 file changed, 7 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >> index 55cdebfa0da0..110d716087b5 100644
> >> --- a/net/unix/af_unix.c
> >> +++ b/net/unix/af_unix.c
> >> @@ -3086,12 +3086,16 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
> >>  
> >>  	mutex_unlock(&u->iolock);
> >>  	if (msg) {
> >> +		bool do_cmsg;
> >> +
> >>  		scm_recv_unix(sock, msg, &scm, flags);
> >>  
> >> -		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
> >> +		do_cmsg = READ_ONCE(u->recvmsg_inq);
> >> +		if (do_cmsg || msg->msg_get_inq) {
> >>  			msg->msg_inq = READ_ONCE(u->inq_len);
> >> -			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
> >> -				 sizeof(msg->msg_inq), &msg->msg_inq);
> >> +			if (do_cmsg)
> >> +				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
> >> +					 sizeof(msg->msg_inq), &msg->msg_inq);
> > 
> > Is it intentional that msg_inq is set also if msg_get_inq is not set,
> > but do_cmsg is?
> 
> It doesn't really matter, what matters is the actual cmsg posting be
> guarded. The msg_inq should only be used for a successful return anyway,
> I think we're better off reading it unconditionally than having multiple
> branches.
> 
> Not really important, if you prefer to keep them consistent, that's fine
> with me too.
> 
> > 
> > It just seems a bit surprising behavior.
> > 
> > That is an entangling of two separate things.
> > - msg_get_inq sets msg_inq, and
> > - cmsg_flags & TCP_CMSG_INQ inserts TCP_CM_INQ cmsg
> > 
> > The original TCP patch also entangles them, but in another way.
> > The cmsg is written only if msg_get_inq is requested.
> 
> The cmsg is written iff TCP_CMSG_INQ is set, not if ->msg_get_inq is the
> only thing set. That part is important.
> 
> But yes, both need the data left.

I see, writing msg_inq if not requested is benign indeed. The inverse
is not true.

Ok. I do think it would be good to have the protocols consistent.
Simpler to reason about the behavior and intent long term.
 
> -- 
> Jens Axboe



