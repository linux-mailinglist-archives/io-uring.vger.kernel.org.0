Return-Path: <io-uring+bounces-1560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6078A5A42
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 21:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 099442848A1
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 19:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3F415573A;
	Mon, 15 Apr 2024 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pdr92ZYq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30DF69DE4;
	Mon, 15 Apr 2024 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713207699; cv=none; b=UFVmarAxKHoVkwgkq8/M0FYyqGVoDbINB0PPC9cwwbqKHxdStMDczmajpRGS3WUll2KjrPScU6Hk9wVW+/q903bkM6C4CxfSHB/trRRMctqqZ9prJfYPJfSySzk9OwaK19gYJmRt5EE4VXwPkiU99Avump4J9CrW+P1DBz56a6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713207699; c=relaxed/simple;
	bh=PnTuE1G9hxqpgJqSaRqkYDATur+oxuaAhti08z7Kc9o=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=ehfqO2i4ymp1CinBZ15y8AildFvJiqbepwRnP+e4IaAa7wMTF1yNsGOfftvVr9/KrWWcx+6YY1N2iQcLeyt3U4jD8weDOwPpeYr6wjSDuO9oh1vh4av83xArfS0o6LV7c50pCEtjOql+u91XkRYhobenhWfJYr4sWtMBQtI5k8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pdr92ZYq; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4349bba0ba3so22166291cf.3;
        Mon, 15 Apr 2024 12:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713207697; x=1713812497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFimitYBHhkcFusGF1JC0a1DtnqMlMykdYmZ+2Zs0AM=;
        b=Pdr92ZYqhjSsEqP0ZJ7+bbHUYAfD7QUTFTcegqwH/HoGIHqijjMJYgs0OuNwn1/lIA
         KvCWSaf+Vk6D5df6ohyHbsX/MqxkU/elo54DuYtIX/71u+WiUorG3iw5v1nYNJcTpS01
         B3gWPCzlDfVXH/zVnL0xmSVg4CPHgi+FSAQoUIi0BdDSiAwjXvCxWF8Z4TQACHBizZab
         IxEU5EE3qbJ9j+AMz7O1eNzB7tMjGpor28QPZ3oT10OQ/MD+WSGZI9pFsoUqaWBXEts9
         HyaR08pg9TURbumuKAKiGPU/5euQktReQsOGH2+qVLEUQW2g8G9B7UTcGcxxco5rj9ov
         xkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713207697; x=1713812497;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JFimitYBHhkcFusGF1JC0a1DtnqMlMykdYmZ+2Zs0AM=;
        b=tTLDfwbjSmfgmyNoXiEAhdsAMkGzK3wO4Zh7XzPWLyrBjhtD4d3O4s2hV6hOGD6Ri0
         2rZ15Oz8ywYGVwRH2Wc0sTEr0fX0gaXwMe75YzuiHNcMiB0SbeWczcIlL01tS1ufToU8
         BJzUPTMVnTeQb4ehcvkj2UqcQYqy4Xx67ZLqKia8uaE2OPYbObUqjDCeuuB8O1Bx8Z7E
         Fq36L9KmL9hCUyN/QValQKYbYe8yiugvctpCTCiHzWtkwGuFNB0qj5L1Ht8FTE6MLSFq
         G2W1QwB/y1N8WVYdCHKbJJjrgUaYtdhb+AoGn4tRbytWsvTnZmAejGfOM3cMVP1k6ufO
         eZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhsuPLT2g9/bT4Cvqujsc8JlGqg+6EhIJTWI7qtrMrpQIS75ZyAzSkNw46Wh8qev3bT9o0uWzDiMpAdkPVS78FlVzte50NnvJ/ipuLdpcCp78TSy+hRDc+tZqeuLuwz/g=
X-Gm-Message-State: AOJu0Yw/zdh2lI/QDRxmXYzhYAAz0gYMEGzVg9yDrcoPq/P7aPzRskuJ
	z+z4scdSudxUqq1XqcKuooRVZRhR28dB3NyCGdouoRKnM/bTm4By
X-Google-Smtp-Source: AGHT+IGNJpsqr6vydFcyFhqNVinfJVqrbmWixrnjCR+tSoFm3TRUYmPs6lW1+SiLftfboxS8dYm7cQ==
X-Received: by 2002:ac8:4f07:0:b0:436:873a:5fc3 with SMTP id b7-20020ac84f07000000b00436873a5fc3mr10967099qte.42.1713207696626;
        Mon, 15 Apr 2024 12:01:36 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id p13-20020ac8408d000000b00436eacea78fsm2464158qtl.65.2024.04.15.12.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 12:01:36 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:01:36 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>
Message-ID: <661d79901c9e_2ce362948f@willemb.c.googlers.com.notmuch>
In-Reply-To: <bc8eb305-84e0-46ab-86b1-907dcf864452@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <62a4e09968a9a0f73780876dc6fb0f784bee5fae.1712923998.git.asml.silence@gmail.com>
 <661c0d589f493_3e773229421@willemb.c.googlers.com.notmuch>
 <8b329b39-f601-436b-8a17-6873b6e73f91@gmail.com>
 <661d428c4c454_1073d2945f@willemb.c.googlers.com.notmuch>
 <bc8eb305-84e0-46ab-86b1-907dcf864452@gmail.com>
Subject: Re: [RFC 1/6] net: extend ubuf_info callback to ops structure
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
> On 4/15/24 16:06, Willem de Bruijn wrote:
> > Pavel Begunkov wrote:
> >> On 4/14/24 18:07, Willem de Bruijn wrote:
> >>> Pavel Begunkov wrote:
> >>>> We'll need to associate additional callbacks with ubuf_info, introduce
> >>>> a structure holding ubuf_info callbacks. Apart from a more smarter
> >>>> io_uring notification management introduced in next patches, it can be
> >>>> used to generalise msg_zerocopy_put_abort() and also store
> >>>> ->sg_from_iter, which is currently passed in struct msghdr.
> >>>
> >>> This adds an extra indirection for all other ubuf implementations.
> >>> Can that be avoided?
> >>
> >> It could be fitted directly into ubuf_info, but that doesn't feel
> >> right. It should be hot, so does it even matter?
> > 
> > That depends on the workload (working set size)?
> >>> On the bright side,
> >> with the patch I'll also ->sg_from_iter from msghdr into it, so it
> >> doesn't have to be in the generic path.
> > 
> > I don't follow this: is this suggested future work?
> 
> Right, a small change I will add later. Without ops though
> having 3 callback fields in uargs would be out of hands.
> 
> >> I think it's the right approach, but if you have a strong opinion
> >> I can fit it as a new field in ubuf_info.
> > 
> > If there is a significant cost, I suppose we could use
> > INDIRECT_CALL or go one step further and demultiplex
> > based on the new ops
> > 
> >      if (uarg->ops == &msg_zerocopy_ubuf_ops)
> >          msg_zerocopy_callback(..);
> 
> Let me note that the patch doesn't change the number of indirect
> calls but only adds one extra deref to get the callback, i.e.
> uarg->ops->callback() instead of uarg->callback().

Of course. Didn't mean to imply otherwise.

> Your snippet
> goes an extra mile and removes the indirect call.
>
> Can I take it as that you're fine with the direction of the
> patch? Or do you want me to change anything?

It's fine. I want to avoid new paths slowing down existing code where
possible. But if this extra deref would prove significant we have a
workaround.


