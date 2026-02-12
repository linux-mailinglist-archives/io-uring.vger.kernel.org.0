Return-Path: <io-uring+bounces-12177-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HwGGyavjWmz5wAAu9opvQ
	(envelope-from <io-uring+bounces-12177-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:44:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CCC12CA48
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:44:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2DFE4300E694
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 10:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974312ED848;
	Thu, 12 Feb 2026 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhYj/0IT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3529BD87
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893087; cv=none; b=TqTX/15XnLotwlfDlfU6McSYOVSa/tbxbbiv0rQY5dkGtjCj4F4FKXHoF9IXIu1ECNPlo8dzHoK1oi65mXNXYuxcYz38mZ6/mIu9Duicne+fHeZzLh0xpQVfPjPTbe5GMi3VT7diA620/Bt8kX5BIV/j1tS1Aq22aRgyrboLHZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893087; c=relaxed/simple;
	bh=17MwG0yNTIWpU9UvgmGZnQhE/JU3V+aOKX7otvBm+KE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mxJaRa44CnN6GHybWtTjcTZtbIdf6iLdPr1xZ3B7UM5iRBZzU5AoH6giXxiR5bcI61iCseEKtczJ0b52leij3rqFM+p+MutU+EeECmYkbSkkL8sUkWABfL2n8HAhGp4FxBq45P0GR9r77dLTo+SSn/BhbrXbgOJFK9yHumjJlHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhYj/0IT; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so80306175e9.3
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 02:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770893084; x=1771497884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHBRvvNw0TKsfp498JIu6yBHF4UlvOdwxk8GoEvvLQI=;
        b=XhYj/0ITf64ffJUY1leh9M/7e/izPPGUg3xcvOokJI5CxJTB4Q1aPtyAsti3SFJPMs
         N9vvD9BGrp0PyIS+/QfgGLgdn9CNzHXKcEXURGb747eoUwVQi9ddurT0W9/8QMMABs1W
         hkqO/bUZmpevnGmY376Rujp5iDtpycbfKszS6zCjOFXyM9/mxX5/tx57V5HQm83euq0P
         stJoXnFQu8Z2CnMCdGWKV5lNqnahfgdclWcjmZY2iDiwiz0jNFhPdqUo3xS32SBSLJEC
         n3qU/oETLG6aVKC74Bsu3C2yoNJ1corL25qvUPoDQKmJAz5P9kWrYOHtcOvw/abj9hRV
         YMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893084; x=1771497884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QHBRvvNw0TKsfp498JIu6yBHF4UlvOdwxk8GoEvvLQI=;
        b=r+FDFLk3u09hle3nDfu/NxfBmDqamUJsdO/EVA8Dh+byz0aqABMCRRR6IP71F1nOd+
         YyhKQR31Jid5d+DoLl1WYw5gmc+O698J8wpZwovKmLrK3PN3CBWhuHENTiXUG2ugdzhr
         vpllZ/ZPt2NKy5VvVwgv7EOJCFaz/q+tnIc/u4QVUajM3sAscO6fJiCXomAhJ13TVk7O
         FRe5wi/CypDCMjXoV7m072jeUAeo84+vPWaV7M03uMIAb2sAIdsGp+S0bAcLJUWZMM6Y
         HcRaHd0slJWcm5csuDlXdl3UvxqxXOOWZt9SPw2pBPXgsUyn9wKI89G5U2oWjtATj7Di
         nUDw==
X-Forwarded-Encrypted: i=1; AJvYcCXdT56PKe6vxIC0uOqpDWTUd9rfylVbeUzCXTwPTYBFFPwT8hdq8ypJlb1y6zX+lLLSy5ypl374Yw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4VZFFsUgsfyqyg7H04x5ztBQfJXuDbGZYGOmByW9Nc/jOIW+w
	qYUWAGmjYMwhBivGlKZCaP1quYZqCiUXsyN+d2wpGD67JKe5TF5VdYcu
X-Gm-Gg: AZuq6aKulsiGmJuQ9C0/iCQuRISW7aCjnTy8Wfxh0sKidlbYkNJnpax27vS5n6OAhKN
	jBEz6skthwEqGUKEpUPz004zFTuWVUsl+2XhNRmyi/wapbxjSyIbALzWr1bE8renQjuaNei/VNI
	E6mP5UpqJUMe1dlYP2LYNI6/zmXKOSutx8JcRm8GKaouZLyYQegUxc67+peUinHxQL8n4WNEGRA
	6ne7Obr2OJ3Twzv6iJMBK2qndDBSCvOtYEznfEeJnfjxxFtWiPOyatKha5PE1QcsOz+knODwdHE
	lDKCtnPY9rlLqfuURxhs+7g/V9eveZzYCQdS+hDDmiGfDN/5+FG7H2LCUauAUhcey0SkgSASNxz
	7Mffe8EaR/QhRij8ZlzLdRrP/Vq9f9IqlNt+EMrraFoaMgudKd1uHoEOZa1lBJBvbbTgVu39+ck
	fIydeCJ3cV4OpGkGu+VI+GfoYlphtlIOq6t8eg24gXNsXDUlBguk6mk0AGA/RlTIgKZESU8mrXF
	+iVQbHlJoOS2sbQlseQ2ENkmeBDNOMrMjn3//IxQvrIhocBr1cYZGO4GGLEv0pv+7pilvydmSax
	wA==
X-Received: by 2002:a05:600c:4e14:b0:477:561f:6fc8 with SMTP id 5b1f17b1804b1-483656ae486mr29560285e9.5.1770893084331;
        Thu, 12 Feb 2026 02:44:44 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835bc7bd3fsm40732625e9.18.2026.02.12.02.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 02:44:43 -0800 (PST)
Message-ID: <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
Date: Thu, 12 Feb 2026 10:44:44 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aYykILfX_u9-feH-@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12177-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 94CCC12CA48
X-Rspamd-Action: no action

On 2/11/26 15:45, Christoph Hellwig wrote:
> On Tue, Feb 10, 2026 at 04:34:47PM +0000, Pavel Begunkov wrote:
>>> +	union {
>>> +		/* used for pbuf rings */
>>> +		__u64	ring_addr;
>>> +		/* used for kmbuf rings */
>>> +		__u32   buf_size;
>>
>> If you're creating a region, there should be no reason why it
>> can't work with user passed memory. You're fencing yourself off
>> optimisations that are already there like huge pages.
> 
> Any pages mapped to userspace can be allocated in the kernel as well.

pow2 round ups will waste memory. 1MB allocations will never
become 2MB huge pages. And there is a separate question of
1GB huge pages. The user can be smarter about all placement
decisions.

> And I really do like this design, because it means we can have a
> buffer ring that is only mapped read-only into userspace.  That way
> we can still do zero-copy raids if the device requires stable pages
> for checksumming or raid.  I was going to implement this as soon
> as this series lands upstream.

That's an interesting case. To be clear, user provided memory is
an optional feature for pbuf rings / regions / etc., and I think
the io_uring uapi should leave fields for the feature. However, I
have nothing against fuse refusing to bind to buffer rings it
doesn't like.

-- 
Pavel Begunkov


