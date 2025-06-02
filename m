Return-Path: <io-uring+bounces-8185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B57AACAF0D
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4696716A325
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2A81F461D;
	Mon,  2 Jun 2025 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KH6SQUud"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635B35968;
	Mon,  2 Jun 2025 13:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748871108; cv=none; b=R5jSkYWDaAsTvlc08eWQgHworHCPkJa41IZvFyRTKpqw20/aDa+9YGf2Pn6hfbjJb0IzYXXMTz1ImJL4NinINbBsT1PY+1XEp3pHYZSj/s5Vsptm7y4Ae1KN+55dqOPfGkBWiNWfGvtVmIP7ghQwF059SzqSIV6RQvlLXKR4XfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748871108; c=relaxed/simple;
	bh=+DFimJ/qczZW7bRdNKT22gELISoWGzumRG2tc0dCMYE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=DaenBGUr/3bFavRSaE2UjzXe3zOJ8hHBzMT3mTLCZGYTKyr4TdPcUlhUjJj4sSxa/Am7CvIpw6bC0nha5jvP06HXKazoauE9g0BmZNyubAcVtwUWv0iuOFMK9TdO+Gpce8IF5Dxc/z+xbf5fv+H1oPbygTDetODA16nxkkIOoM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KH6SQUud; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6face367320so32093246d6.3;
        Mon, 02 Jun 2025 06:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748871106; x=1749475906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7uDhYROBVHKQ3j2ronpzeARhgnkBg6U6c2yIwDBn50=;
        b=KH6SQUudOI4OGTEfg3Gy7y0Z7ZYIymVPDb/he622cWQJ46mpcnyg+/D7E/oqaar+N3
         EFiHsv0tVg9u/W2qvwhpYjLgyA7DWnprpAfP0y+wRp0dyTS9T+e61TJuLEA0TXnP5YmR
         St2lAKngfd81SXg9pw8lzntuHInBfeVE7270MN9Y9pzbO/Amk6ZPBPRdOj0QqJkxKyxL
         krJgWQxLeWRzajGBohZ9fc1BCDAYQmICOADOKDeHtO7mfkXX46CIUOVhbP+4iOqtNTkM
         3UHSyWcUlvftS1IdQ3Ufi3YlYksIYueN0aG+pLfKgYJ4SGj1d0nsYuvuxvQAIxy6cqlp
         rjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748871106; x=1749475906;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b7uDhYROBVHKQ3j2ronpzeARhgnkBg6U6c2yIwDBn50=;
        b=iGP9Jc/yB+r7ZuaeP1mNWhofgg9E3PICx4dF9VwKLGk1gTn34pYoqIEsgIVuOqaDFt
         se8R3a0IRkZyr6+AMoTQO9EFj+oyWVpaq9OP4I2UevmrBoOGNziXnsAu+OfQViGMdaVC
         86jVO9E2Oet/pJopNx1NFO1yPVLEOXZJv62+KRHVj4psIsB8imWalo1zQfZVsPRBcuHS
         64fMqJDXQUHWz2NxN/4OamTYYzZIbxueVgmp41kxL7BJrZq9BSZsNW+AVIiW9G4rTPCg
         jMGZrDy4lgLkWVDWCf8yWf7smm4Ar2ESH6eE46ibWR2OStXPAnePKqjt/tIe7WHtwd7P
         Mx1g==
X-Forwarded-Encrypted: i=1; AJvYcCUt8RfaC9hoVlAmzSRPhqIKv7J9QIFcIyfO85CcUXGsGNl5lZfcGsju8n2lKgarrMU6FZItOVIQ8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCRBId/3sKMIdobc24TwjFhAshiLlBoG49nDGyXhr+GiJxtF3x
	F9/QQB8lUvy9L7NTwStob0LO93cnrsHnaXcZF3DdHvnPNJ05uYIKEDwEQcOFsA==
X-Gm-Gg: ASbGncvximo1gPnXM9agSza6WKZRrQwEFalgIDx8SPYa/pYimj5DNOV6lHh+SLeIXMR
	V48f3sLXJk7uMzF/Y0ljm+F0+4C5EZoorhMoUp3T0o333jng9xXsQhWOEh+WUJCe8GlVcctjn63
	m4sfX+U4Kc9CXz6lZLvBS4jUDdaOaOsbMFPEdJx+kCCNT36TubjVo2xwvkAOePP0uDyz7qiCjDB
	A/MI06gkfYtPlTlYi5BGC9qfo86wk8A4bVj3LLPyP3OeROackVLfUJruMSSkkKJOzNUNmYWu0ZE
	wXBXlbQg3tamH9J6pfev7bbGNbi+zIvQbzBHVju+oFm5W5BLPViQ6Fty4VdJJwnLMwKFJAZf5sQ
	tRK4hUo8imQVVe4eYBkxBdhI=
X-Google-Smtp-Source: AGHT+IFJEFSb0+Iffwq4ZPTwf6C3RZ8h04DQf58ILuOKZq0iFkFqY7Pc/pBZLRWhDYHLjjO3mccDrA==
X-Received: by 2002:ad4:5de2:0:b0:6e4:4274:aaf8 with SMTP id 6a1803df08f44-6fad191c252mr186689666d6.17.1748871095063;
        Mon, 02 Jun 2025 06:31:35 -0700 (PDT)
Received: from localhost (23.67.48.34.bc.googleusercontent.com. [34.48.67.23])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6facab00339sm57167846d6.125.2025.06.02.06.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 06:31:34 -0700 (PDT)
Date: Mon, 02 Jun 2025 09:31:34 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <683da7b621fc2_328fa4294e0@willemb.c.googlers.com.notmuch>
In-Reply-To: <07d408c8-c816-4997-ab87-1a6521d0bacd@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <6e83dc97b172c2adb2b167f2eda5c3ec2063abfe.1748607147.git.asml.silence@gmail.com>
 <683c5b38ed614_232d4429431@willemb.c.googlers.com.notmuch>
 <07d408c8-c816-4997-ab87-1a6521d0bacd@gmail.com>
Subject: Re: [PATCH 1/5] net: timestamp: add helper returning skb's tx tstamp
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> On 6/1/25 14:52, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> >> associated with an skb from an queue queue.
> > 
> > Just curious: why a timestamp specific operation, rather than a
> > general error queue report?
> 
> Timestamps still need custom code, not like we can do a generic
> implementation just by copying sock_extended_err to user. And then
> it'll be a problem to fit it into completions, it's already tight
> after placing the timeval directly into cqe, there are only
> few bits left.

Ok understood.
 
> Either way, I guess it can be extended if there are more use cases,
> or might be better introducing and new command to cover that and
> share some of the handling.

Not a request from me, to be clear. Just wanted to understand the
design choice.

> ...>> diff --git a/net/socket.c b/net/socket.c
> >> index 9a0e720f0859..d1dc8ab28e46 100644
> >> --- a/net/socket.c
> >> +++ b/net/socket.c
> >> @@ -843,6 +843,55 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> >>   		 sizeof(ts_pktinfo), &ts_pktinfo);
> >>   }
> >>   
> >> +bool skb_has_tx_timestamp(struct sk_buff *skb, struct sock *sk)
> > 
> > Here and elsewhere: consider const pointers where possible
> 
> will do
> 
> > 
> >> +{
> >> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> >> +	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
> >> +
> >> +	if (serr->ee.ee_errno != ENOMSG ||
> >> +	   serr->ee.ee_origin != SO_EE_ORIGIN_TIMESTAMPING)
> >> +		return false;
> >> +
> >> +	/* software time stamp available and wanted */
> >> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) && skb->tstamp)
> >> +		return true;
> >> +	/* hardware time stamps available and wanted */
> >> +	return (tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> >> +		skb_hwtstamps(skb)->hwtstamp;
> >> +}
> >> +
> >> +bool skb_get_tx_timestamp(struct sk_buff *skb, struct sock *sk,
> >> +			  struct timespec64 *ts)
> >> +{
> >> +	u32 tsflags = READ_ONCE(sk->sk_tsflags);
> >> +	bool false_tstamp = false;
> >> +	ktime_t hwtstamp;
> >> +	int if_index = 0;
> >> +
> >> +	if (sock_flag(sk, SOCK_RCVTSTAMP) && skb->tstamp == 0) {
> >> +		__net_timestamp(skb);
> >> +		false_tstamp = true;
> >> +	}
> > 
> > This is for SO_TIMESTAMP, not SO_TIMESTAMPING, and intended in the
> > receive path only, where net_enable_timestamp may be too late for
> > initial packets.
> 
> Got it, I'll drop that chunk if you think it's fine. Thanks
> for review
> 
> >> +	if ((tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
> >> +	    ktime_to_timespec64_cond(skb->tstamp, ts))
> >> +		return true;
> >> +
> >> +	if (!(tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) ||
> >> +	    skb_is_swtx_tstamp(skb, false_tstamp))
> >> +		return false;
> >> +
> >> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
> >> +		hwtstamp = get_timestamp(sk, skb, &if_index);
> >> +	else
> >> +		hwtstamp = skb_hwtstamps(skb)->hwtstamp;
> >> +
> >> +	if (tsflags & SOF_TIMESTAMPING_BIND_PHC)
> >> +		hwtstamp = ptp_convert_timestamp(&hwtstamp,
> >> +						READ_ONCE(sk->sk_bind_phc));
> >> +	return ktime_to_timespec64_cond(hwtstamp, ts);
> > 
> > This duplicates code in __sock_recv_timestamp. Perhaps worth a helper.
> 
> I couldn't find a good way for doing that. There are rx checks in
> every if, there is also pkt info handling nested. And
> scm_timestamping_internal has 3 timeouts , so
> __sock_recv_timestamp() would need to duplicate some checks to
> choose the right place for the timeout or so.

Ack, then let's leave as is. Thanks for taking a stab.

