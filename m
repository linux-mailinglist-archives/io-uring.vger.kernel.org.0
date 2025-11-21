Return-Path: <io-uring+bounces-10718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6A5C791F7
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 14:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A9BBF363AC2
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 13:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E439B346784;
	Fri, 21 Nov 2025 13:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/QMZl9S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10E934403C
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 13:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730174; cv=none; b=VnZoyZGPa/RvbI4mwu44M/y0Xdoioy1AkJlffQ6Jvq7gi3dwL0U+2kldR+5Qcnua4RM6vWzsvH1Vr46aGewS9yZ8D84HVdMyUVitYmRnrAOQP9fvSuhX2l9Z1fbqWdqaXIbcoJtaJh+yZOqTAmcFvTDwS4fOIPCth2bNWTOG8lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730174; c=relaxed/simple;
	bh=J1sxZerVx4LRZu0MxMnZWpDHNosS86+OSOr1kLRBwM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXf9CiTF7d43x7JJ/3tynlqLw+ly2YnxmXkSaYAGawBtXW8KyUe8NmzE4RAOPZ5por/SM+u6uJ5lUtJDbt1lz0rLpUvTwt7QM/h33I5mGe3f+xDnJOrXCCwwB3wdPHqLoNqkWsuPCHlyiTU56ERwAmhDx4EBRwJzAHEOHK3un7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/QMZl9S; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47789cd2083so12314055e9.2
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 05:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763730167; x=1764334967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+karDUIwaluMCQfDCqIqXlR93Ss9N56UP9ZbbJblk6I=;
        b=b/QMZl9SE326qcHee6Oe+yDe/0hEzLuxg0NHt0ZwFIL4lvgD0Zc5GhMXn23hJJfekL
         QcLkv6y7hdAolxzBBSUGaY42RtW8W5sqRdIrnxqLiN46/xrjT38Ji68d3RcnxfsCdEX6
         cM1txrMc7jybwEWQgYu2IgR+DdGamkg6xXpyqyijOHcIP5Q1FzjHHiizvDmKuxNKaYqe
         drcE0AERfMpOHUlpRqywY5W0McD2KkL/LtZ+2JNtI7Pd9cPmVaIwHMkL5N2OHycWGNRw
         jtgVmxZkDyYmIEESB5b1tvkZTczWYq6x8wUukyqvRkHf9BuqsX+6L/X10vFrqVrmmY73
         uTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763730167; x=1764334967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+karDUIwaluMCQfDCqIqXlR93Ss9N56UP9ZbbJblk6I=;
        b=xT9zf/Xu9Hu8pOWhgs2GmTYVYQeXz+5+3Jh4k4UhlNOrjsqKdlkJWJKGFEA1T8BYOd
         SEX5gHO0depLcQp3MOcGkUBIMVOevnRlNWbUnL9jm8uOXttDAuUOL/lirNylTpp3M7Um
         PJGCO0MEVv+nyyiGFb6VD0G5MKjOCgP/ye11NBZkPlfuGFwz8ERTqD0yndNyWx1gFks9
         agjP+qJiiiECyvBuTVWR7VUTkcxxQ6BdPoiNXiNpdAnd03CpyfcBBbDUejGpPv5ybLxK
         7v0sYzh7mHXOfD7UcGomJ5CycnCwFxZGo3aj1XxSFBSQW9plJLNqCkafTSDe73YyO9Kf
         cdTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjR1AJN5Jin+tlm7ilHMe5cRvMSJF3j4F4yRCUaqyi5pPR5CYADRLyiTxqYSGkaQZ3zDT9GHGttA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz94Mf9+dWPTmqbMbM8uuCjsj5NbswPkXANzWKAMmSn6phafnmf
	CK/X88o//ugYNrbzunjSKfqXF6pISvP1v92dY6W8uSLGVJj1BxkwyaY4
X-Gm-Gg: ASbGncvO5CSNbXjMNIaf6Anj7mCg4lm/TQsTxBDKM+USBDld0qkJFzrJWD8heWhOaVf
	vUCccZNqYe6t3u43SPNtoyhP+d8CASxInC5TmHPxGoH462NEspsGQH3+01+lzvZvTNNDP6nOP8u
	psEN9cqG1e0crp5tl0Tu3a73YyVjeX2dErYEOmcre6SuF/ciN8tGwoqz/JKP4Oa+IVui9casod7
	JIlzu/a93SA7pNA+JcDvG2wsKhL0wwa5y8a+uNQSva7zNq5ghxUHemVps55otQERwK2uLZ7E9JS
	fI6Tpf+9xsQp8ZSpCOIJo9jXynbru5SCRtAApmPdYtmSrTa2xh3FIgTpY/FXQH7mjaxmNgelSRB
	FBfO4cCJV1Zt4FJwuNB1GwRrODpfdfKkTmdoxkuxXR9MyAFwG1E6qInqk1XFMoP0Q4wvORprisS
	OPAJabtPCDbtimiXDe2Dpf4NdIyOcnjQEpQ5agjigwGa8=
X-Google-Smtp-Source: AGHT+IG0dHMzWmFJj/rAQgcaWfg4AOgSKobtzdJcmRQ7G8ZljQW4t5jDW4Xt3mXuEOEmi28tMC7DZA==
X-Received: by 2002:a05:600c:a07:b0:477:a3d1:aafb with SMTP id 5b1f17b1804b1-477c115c657mr22920655e9.29.1763730166896;
        Fri, 21 Nov 2025 05:02:46 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:813d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf36d1fasm41153185e9.7.2025.11.21.05.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:02:46 -0800 (PST)
Message-ID: <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
Date: Fri, 21 Nov 2025 13:02:44 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields
 through @desc in net_iov
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
 dsahern@kernel.org, almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
 io-uring@vger.kernel.org
References: <20251121040047.71921-1-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 04:00, Byungchul Park wrote:
> Convert all the legacy code directly accessing the pp fields in net_iov
> to access them through @desc in net_iov.

Byungchul, that was already converted in the appropriate tree.

-- 
Pavel Begunkov


