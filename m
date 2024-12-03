Return-Path: <io-uring+bounces-5191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EC39E1ECB
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 15:15:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A910D163C32
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83FD1DE2DE;
	Tue,  3 Dec 2024 14:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCddm43y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C561EF08E;
	Tue,  3 Dec 2024 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733235339; cv=none; b=RSBh0SQ9n954YIeR6arLIueFBroEKyrkcY0GZnBYKT705whYNdLRzFTHChGrI0SuYViAIUx3WaMwOxHMzwOBZITa0pdIPiytWrolcxNORgdXq0tamQ7VYDQbDjOMQabRF98ZewVqT+Yovo1EagJ8jiPoUhytFFYjjKri/NNoCHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733235339; c=relaxed/simple;
	bh=zSTDCrhl39CkrMGYnZe8NnPuB1bxR1LQTwoiWSUEBgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jsp6lsCR5wx846IJ2cloyhjaBXvi5azcM8TBDg2T81Z66M3NOTRJLLouikWA+BNVeZj6ydhaICoYlq+Gxa2azajFdIrWGVasvl1oaTUKOJfIExInDe2zkbvCSkpiQnxbF8j7tnVeC1mk5kmYGsGv6VboiPkzZ4UhjOqQW1KyaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCddm43y; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa5366d3b47so889718766b.0;
        Tue, 03 Dec 2024 06:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733235336; x=1733840136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K8TjMXXYvtLriLWmwQ310C6UlMQ9PVqAXnSPL0N7z4c=;
        b=OCddm43ygU7oqKcO4h0J94/oRVMTWuIESCEMF4mKQBuwB75ZoRGKqx+ELqcS8lDMHQ
         AtaSJfXBvF5c1LhXgBjgjJnwW9lkDtl9q/IR3w3GjZcpJayVNRwUMqByTejKxEJLgW5L
         A+2OC+oVxYUIgJKjH58aWKCEGFywbZARU9AajZaaPFjjDBsAlmBTIWnkjLtlEuSzcppQ
         nSDXe8xvdTCYWSyZb8xHetH7yub/iFikUrpvlIOAUdGzj4zHlui5zUshiFrPpaRnK5W7
         7yuAGdmndfDMW5APPhE0dW5Lyle66LIn9XyRlBdkagMIorjoX7h2rH55g+l8045+inZU
         K7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733235336; x=1733840136;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8TjMXXYvtLriLWmwQ310C6UlMQ9PVqAXnSPL0N7z4c=;
        b=LbFHEDR3d3pczPkpCgL7enPlgApMdJ/WXaYgKlZH40J93wF3EiDKccBGDvCAHzHmbr
         kC/Cf/CIsX6ghbXBnk7JdEQlUDobF9bkTKTtO8iHO4UzLKTasfSZ7eOg8LbgykfJwKDv
         Ug7BWygKI9rOxN8Y7GXYMsESiLBxx5Mtruu2fYoRjQeMiKMAtCQaJux+Yh2zX7jzG6Sw
         USAEmT/KffAnC+l2DBq5XTbEU7/rn5diHt20HG7p/MPvRVz7e9BxJHJcgI806lNokJ5K
         YNBo9drxlz5DyxHR92mX6YavAi+RnrfdK/+nnbs/86eF3kIBOcHG1NxZESdYHnu6YAMW
         V5oA==
X-Forwarded-Encrypted: i=1; AJvYcCUnFFj2Pj7pGRkimRj2H+XlxQUX7gtIIAOKm6K2AHC407HlpRbdccDeAj1vIcVNks3R5iga3CdJpw==@vger.kernel.org, AJvYcCXAmh/0P9oCUgW0gXv2sUjJow0xjY8yLkJmYpt8kfC5gJ2Ah3R3n9IjSS+uw6swP6XpNUEkeoICyuo9DDYwzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyawrhJAWImNk3bGMx9njGbuyKqYHkX+R8X+Z8M9tfY2eIJhIGV
	Q+lu/HRy39QFyC8zckCgtLDoRFt+UzONdzzFM4CyED/5YJVLZMfq7/wTSg==
X-Gm-Gg: ASbGnctLqjq4C/BNc0G0AmP1Po7ri82JRyGpgk5gQ18DIjMe/iK/YCmAq11uVsE1rET
	PJOEeBHunYZlHjAH/6QnTmmwrpWV3Ga2gkvaa0xBfGnyn3izwy44MptzxWeBik5KG+Lh8eyVDz3
	fljrgMtolmVEal8sT1xvT0BAu5nMzhGg/9qf5W8IH/WB4S43MLGeMus5TOgYTvaH94td8J5xai9
	c7ekTczLu5EXNmD9Z9qAYRRIbs288h9JcHaH7hMUhPhC5S+cHoOHVpsPqNjNw==
X-Google-Smtp-Source: AGHT+IHVfay3h+psid9ShXen/yKdzf+4BTxfb7xDl8My6jgUanUzUoxyDVIlqKBrIQ8vX4NOlWBlWQ==
X-Received: by 2002:a17:906:318e:b0:aa5:274b:60ee with SMTP id a640c23a62f3a-aa5f7ee66c5mr220987866b.39.1733235336171;
        Tue, 03 Dec 2024 06:15:36 -0800 (PST)
Received: from [192.168.42.182] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5a44f10c5sm551341466b.166.2024.12.03.06.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:15:35 -0800 (PST)
Message-ID: <152e54a9-b54a-4aa7-be24-7adfed06de11@gmail.com>
Date: Tue, 3 Dec 2024 14:16:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
 <42d5cd02-a1b9-4cd9-ae92-99bdcac65305@gmail.com>
 <07e4b270-f6f5-471a-b2b7-4fb5027fdb20@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <07e4b270-f6f5-471a-b2b7-4fb5027fdb20@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/24 13:49, Bernd Schubert wrote:
> On 12/3/24 14:24, Pavel Begunkov wrote:
>> On 11/27/24 13:40, Bernd Schubert wrote:
>>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>>> For now only FUSE_URING_REQ_FETCH is handled to register queue entries.
...
>>> +    /*
>>> +     * Direction for buffer access will actually be READ and WRITE,
>>> +     * using write for the import should include READ access as well.
>>> +     */
>>> +    ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
>>> +               FUSE_URING_IOV_SEGS, &iov, &iter);
>>
>> You're throwing away the iterator, I'd be a bit cautious about it.
>> FUSE_URING_IOV_SEGS is 2, so it should avoid ITER_UBUF, but Jens
>> can say if it's abuse of the API or not.
>>
>> Fwiw, it's not the first place I know of that just want to get
>> an iovec avoiding playing games with different iterator modes.
> 
> 
> Shall I create new exported function like import_iovec_from_user()
> that duplicates all the parts from __import_iovec()? I could also
> let __import_iovec() use that new function, although there will be
> less inlining with -02.

I'd say we can just leave it as is for now and deal later. That is
unless someone complains.

>>> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>>> +{
>>> +    struct fuse_dev *fud;
>>> +    struct fuse_conn *fc;
>>> +    u32 cmd_op = cmd->cmd_op;
>>> +    int err;
>>> +
>>> +    /* Disabled for now, especially as teardown is not implemented
>>> yet */
>>> +    pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
>>> +    return -EOPNOTSUPP;
>>
>> Do compilers give warnings about such things? Unreachable code, maybe.
>> I don't care much, but if they do to avoid breaking CONFIG_WERROR you
>> might want to do sth about it. E.g. I'd usually mark the function
>> __maybe_unused and not set it into fops until a later patch.
> 
> 
> I don't get any warning, but I can also do what you suggest.

Got it, no preference then.

-- 
Pavel Begunkov


