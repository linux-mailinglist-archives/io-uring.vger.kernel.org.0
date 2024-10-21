Return-Path: <io-uring+bounces-3861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A57659A6F26
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B85E28349F
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0280D383A2;
	Mon, 21 Oct 2024 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HowjmMhb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE72C14A90;
	Mon, 21 Oct 2024 16:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729527316; cv=none; b=t1b+EYyug54zUlAvkX2o8EJ5zjRpK4O7wxZJCDcDqBSD0knKdoiz19SaHrbhQ46Ed4Cd9RHgfOnITCSaAc4phxTX8ADQKzI8M7aiDJXvrl7oanUkGr5jrXoLO+gpiDVep3AChKfBOj6hT10QuqIU/sy5oa3Ye7RUP6ZYp7HOiRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729527316; c=relaxed/simple;
	bh=uKHF4baTL2b1LM7brqBE4ES9KdbI0j2PrW2vf/wHO88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LUDgVMS2nyzhX0zJTANz7WxXSS/pTkcJlqafZ00+wpIyX/0IV7+OVR7pScC+eamG07RuZP7pc9qjsQoi9JNrNfHElGeqP6ATpv13jpT4KJcXwyXEsZJM5C4vmUL/vhiS7ux2SqL9s1j2X5YngwMHdBJKZECCdCq6Id0NWVEyEeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HowjmMhb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4314c4cb752so49600805e9.2;
        Mon, 21 Oct 2024 09:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729527312; x=1730132112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cIsemXgD2zLS5xTiDFxvunxQUn7idX/rzIf5fUQT+0I=;
        b=HowjmMhbVwbNjE82S8rGg7yPBm1UroQYcioloLVqLJZKtDwo4ZNoM9kCk/rDLa0MCp
         NJOXScT0dmneStJpKq9g2FwndEdRVa/6fforZMHgXGXatHQUAF6/nlZBuoAvb8kb00mk
         8+2HVI2RX9kHqn+ca93NhrCb+DRZ0z3VN/nMDA61ljvMVkvKirBysJxdvamPNWLiz5A6
         6aYdtgFLAdb2LEr37y0uCFbvZT00o+Is2LXT8Yto87MBli0hZeikkx0GkdFmt5lnSDms
         LyD1gYaHPL6ag2NgxnDkG5UK7HYBA4vYUJiRoRmwiODe4dm0yLFtcHUrVX388SgKFp4i
         N8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729527312; x=1730132112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIsemXgD2zLS5xTiDFxvunxQUn7idX/rzIf5fUQT+0I=;
        b=Xr0DNTPQoBfQDTgVHYXbGH7s8fgMwAd/tgkU8wzsXNDN2b4YDYyX4OAt4Dsl8LL6RI
         TlacTddJTOMinVNrjhbG3LKHtHhFDQID8TMftQBI//eEIGNmKt4joWNz5JIg6/uv1xQp
         sVwTxbZcXioFKHw4vWMxup4GQx4ZTdzKFt6DhrJ4II0zx26NZxsPj/rkbtw2nSoDp7c5
         Hka/lo8UfjwBU0Z2DxmirmEZ3Wb8vZCbC5UVpOwz8MNbDgM2rILmTUZsptiVlV2Q8/cw
         X5owtrFlPcnVlKA0icBC8KF5gM5/mqp+LZ4+aWUZzOP6HxIzMZHXzN71/HDDdI7WyXVs
         LECg==
X-Forwarded-Encrypted: i=1; AJvYcCUEprErz+DR1ddb97DdhXM+XRe8mpBixmd5SOns5g6csUdaMHkgNeZTMCHa+lhWFp+dUXMN2G2yVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YykmGFXtvdNyn8rzECso5nBzJRzwmLQAeeWmKuz1WCp5jAbwYJh
	t9UAu9zbSXoyc//WnOJokVYBs40FK1uQkUZZG1H90K7y+nMORfaZ
X-Google-Smtp-Source: AGHT+IFnU6egggjQcJmjVZ+/a/qxvykd37A4okRvonAoJpXWq3UKWyiE/zDc7mIKpSYLDbDnmkCH9g==
X-Received: by 2002:a05:600c:1d27:b0:431:53db:3d29 with SMTP id 5b1f17b1804b1-4316164237bmr77263405e9.18.1729527311768;
        Mon, 21 Oct 2024 09:15:11 -0700 (PDT)
Received: from [192.168.42.158] ([185.69.144.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f5c300csm62290165e9.30.2024.10.21.09.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:15:11 -0700 (PDT)
Message-ID: <f9f16c2f-ed3c-4509-a40f-c71878354a8b@gmail.com>
Date: Mon, 21 Oct 2024 17:15:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
To: dsterba@suse.cz, Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-6-maharmstone@fb.com>
 <20241021135005.GC17835@twin.jikos.cz>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241021135005.GC17835@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 14:50, David Sterba wrote:
> On Mon, Oct 14, 2024 at 06:18:27PM +0100, Mark Harmstone wrote:
>> Adds an io_uring command for encoded reads, using the same interface as
> 
> Add ...
> 
>> the existing BTRFS_IOC_ENCODED_READ ioctl.
> 
> This is probably a good summary in a changelog but the patch is quite
> long so it feels like this should be described in a more detail how it's
> done. Connecting two interfaces can be done in various ways, so at least
> mention that it's a simple pass through, or if there are any
> complications regardign locking, object lifetime and such.
> 
>> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
...
>> +
>> +	kfree(priv->pages);
>> +	kfree(priv->iov);
>> +	kfree(priv);
>> +}
>> +
>> +static void btrfs_uring_read_extent_cb(void *ctx, int err)
>> +{
>> +	struct btrfs_uring_priv *priv = ctx;
>> +
>> +	*(uintptr_t*)priv->cmd->pdu = (uintptr_t)priv;
> 
> Isn't there a helper for that? Type casting should be done in justified
> cases and as an exception.

FWIW, I haven't taken a look yet, but for this one, please use
io_uring_cmd_to_pdu(cmd, type), it'll check the size for you.
And there in no need to cast it to uintptr, would be much nicer
to

struct btrfs_cmd {
	struct btrfs_uring_priv *priv;
};

struct btrfs_cmd *bc = io_uring_cmd_to_pdu(priv->cmd, struct btrfs_cmd);
bc->priv = priv;

You get more type checking this way. You can also wrap around
io_uring_cmd_to_pdu() into a static inline helper, if that
looks better.

...>> +
>> +	start = ALIGN_DOWN(pos, fs_info->sectorsize);
>> +	lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
>> +
>> +	ret = btrfs_encoded_read(&kiocb, &iter, &args,
>> +				 issue_flags & IO_URING_F_NONBLOCK,
>> +				 &cached_state, &disk_bytenr, &disk_io_size);
>> +	if (ret < 0 && ret != -EIOCBQUEUED)
>> +		goto out_free;
>> +
>> +	file_accessed(file);
>> +
>> +	if (copy_to_user((void*)(uintptr_t)cmd->sqe->addr + copy_end,
>> +			 (char *)&args + copy_end_kernel,

Be aware, SQE data is not stable, you should assume that the user
space can change it at any moment. It should be a READ_ONCE, and
likely you don't want it to be read twice, unless you handle it /
verify values / etc. I'd recommend to save it early in the callback
and stash somewhere, e.g. into struct btrfs_cmd I mentioned above.

> 
> So many type casts again
> 


-- 
Pavel Begunkov

