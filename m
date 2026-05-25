Return-Path: <io-uring+bounces-13500-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNaWEWf6E2oxIQcAu9opvQ
	(envelope-from <io-uring+bounces-13500-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 09:29:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C09335C725D
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 09:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 605F93005777
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 07:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E737E3CF691;
	Mon, 25 May 2026 07:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlHC2Qlk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C5226E6F3
	for <io-uring@vger.kernel.org>; Mon, 25 May 2026 07:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779694154; cv=none; b=dFOfUDSzqxXSpYfQ3UsI6OJwnrIknka8zE55CJ/QR7uKD861iu8XPvLMeQ9P+kbjQZccs9x4tZ6DxWMq9VFE8FFF7tkN5SCf/UwPfc7d73SSWFkTkTc+0lJ538CL1YkeO0mUYOZWb7Wa+v+dF12crth0OvxHp4ztle1I6ECSUO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779694154; c=relaxed/simple;
	bh=Dg6xOhAfC8nAS8w2UlP1hkcGBI6/eEQ9ST3cagLZT4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTCbwqMN0QrnUFavWbHhK4H10DfGGOnr7zZz5tfLZWGfWcHPU9Kzc3bmhYKOqpyDyzDvtnnnTzzOBRSK+VrQKS0HPf+JnQwzImRrSQflH4to7/8yHOOxVjztBQZVVO3wrD1fM1OLwzoCmarpSGL9bUtcXLYYuBEXjkR7jrniEVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlHC2Qlk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso117423245e9.1
        for <io-uring@vger.kernel.org>; Mon, 25 May 2026 00:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779694152; x=1780298952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m+/CremarURMLXbq9HZsozt2//0CtuRcgdYp3OMzrIs=;
        b=UlHC2QlkIb4XLnXGJy7wJ9WEAIolGMLkGZ4XYlME8S5AEhdyWcsYCae0wgtAz5uZ6+
         wDxbJJc9Qcy9N4zpjKC7zI5pmqbWBoSZDbWXiLTEehoIUXCaj34l+WX6RaOvip1EfiRN
         BWYI+Lt8tA7PBSZL/Rc7fB0gydpI+H2O6cCgLPmW57JUpG8J7z0/QgZ2aUm1B9SPftOE
         Rp+dcu5/00PDGT9i0OHnPZ0cYSSdG0yV5Eq+2sDJGN61sVIoGEdfy28aIcecT3IQko+W
         ZWSGztFHDohN0gSU1UiEHLFPN28TmZTWsrNkupph4hd+MoKIvQjrfq5Tc9IWiVAk6hog
         kHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779694152; x=1780298952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+/CremarURMLXbq9HZsozt2//0CtuRcgdYp3OMzrIs=;
        b=XKVTDKxj/X9FrMHqH61bY7yzIZfUJ4fe/UYYiX4rpFzXLy1qv0tScSczZemDCz2zsq
         GLPZhPypcmo3O7DuKTiHXmi4Wk5NFYoWHKkJ5yLukmG81e84FpNfsKfREiO8OEybhqtU
         HVwRVxcbsW2BfBgOH3/z0MV7jrzVPe4bwkSdO8LxutfZ6LFA2nnwtLlQC1qCSaEtY0Ce
         aWCuuAYSZxdH+i/DkKGCclH9vzTPrGGkz31ot8SfT05N/Ezh7LJ1ZAix2Ohg/Gu9zYxW
         0sWlaD6su5+u7nS8wqNr361jnnmn5GmWrwIqchkX4afLH8u/zIMOFaukljVsIPTwpjbZ
         ZR5w==
X-Forwarded-Encrypted: i=1; AFNElJ+/TmAry3I1/aZ/xaG+jbwcg2uomTqM9imw9HqHZ1MVPGe9uF8iXpin9Fj9YKVA9usmWc1GstVa0w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk/Rq+wxh398Hb0xJenqWFBbpMTS/bGU/5anqd65TkU++M/+2S
	6Llfu7gG4Va2wqFIaVMSZOYy/SPG9/8rfviJGJ3He0V5TrdWxmuIfmrJ
X-Gm-Gg: Acq92OFNZuC3ngJPlJtnQm5sOwFib2WgsQiQvERZ0E0OY391pqeR4WaX/JN0ToOTsOs
	HubmQnQCHi4wbDIqywkdGCBel8x5K8+wp6VrKWBTdwJs+N6eHwTp7ENVQrMW9zVEB9lMnWoTXf6
	hUEdwi38QYbTBNE90f0OyqxCHiQWEO5qamgrGBtF++VO+ZiFfClFmfhZOomf+m0W5Q4rB8TcfJ6
	SQafzjSDE8Z+O1UtL9ltKdNNFcTZvPK/h6gkC+gEieDMO1Xm7aWkmJWWwno6f6NWv6oIn3Plh3b
	IQzoOJWQICuPIkZwEhMjqOka0kHEwngsfFgW8zT17SG8jV9J6Nt4MvOxq5WnUL8oFFO1cw7S8Lk
	T0TinmdyI4+/8s4q03ELrGIcV1lYUKs5pz6pqIzNTj4afR/QCweGHqAURxpyrvCQbeqouAyKUKn
	RzmA/4Tt9VIkKWzvRP5+0k/oAnFGMov+uTs2B4SBwdlLnFFINOqxGunI3ylqsjybx78X2zH1Qy4
	U8RwSYV5/l3VnHwAnsMAO9k3Ur6BxLRFqyTI0yIPnlL3IN/DEA/MmepafgdCAiiUbLVDaII05fp
	3P+pVWCBg0H2PtN5lGcmEn8=
X-Received: by 2002:a05:600c:c4a1:b0:490:1640:8269 with SMTP id 5b1f17b1804b1-490426d1a16mr227253215e9.18.1779694151663;
        Mon, 25 May 2026 00:29:11 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d4cefsm81771025e9.14.2026.05.25.00.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 00:29:10 -0700 (PDT)
Message-ID: <57ae2e2f-8523-4cba-ad77-920535edd236@gmail.com>
Date: Mon, 25 May 2026 08:29:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
 <20260513081929.GD5477@lst.de>
 <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
 <20260520083043.GA18893@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260520083043.GA18893@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13500-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C09335C725D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/20/26 09:30, Christoph Hellwig wrote:
> On Mon, May 18, 2026 at 11:29:54AM +0100, Pavel Begunkov wrote:
>>>>    	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>>>>    	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
>>>> +	BIO_DMABUF_MAP, /* Using premmaped dma buffers */
>>>
>>> Shouldn't this be a REQ_ flag as we should never mix and match bios with
>>> and without this flag in a single request?
>>
>> Do you mean adding both and propagating it from bio to req? submit_bio()
>> takes a bio, so we still need to set it there before it reaches blk-mq.
>> And there might be bio-based drivers using it in the future.
> 
> I think I forgot to reply to this, so let's do this now.
> 
> REQ_ is actually used by both bios and requests, so if you set it in
> bio->bi_opf it will automatically get propagated to the request, but
> it can also always be tested on the bio, including by bio-based
> drivers.

Ah yes, good point, thanks

-- 
Pavel Begunkov


