Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31618EAA8
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 18:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgCVRIv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 13:08:51 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53785 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgCVRIv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 13:08:51 -0400
Received: by mail-pj1-f67.google.com with SMTP id l36so4982516pjb.3
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 10:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uhZEICrCDXLwlJHXRhIYNSI4X4GFiGMWg1GuHfipZ7o=;
        b=T80uqZlli21a+cSZEpFgPbXdFFEHuy0+yg0tjEe3oCT6XW+cHAwE3CV7kc4ZjMtUIy
         AlJ0SJVGq/nVKo3draTjlasgr9BcBJ3ViMA1GjIE+Ze8F9m16J+1TjixlxbN4xhfOuD/
         /eDpgJLzbQnnFUeC86mn5aV6g+3bJrkN5PxWPAGUyJ8GTmw4mv/CnVDvqRxjtgqC1M5J
         Owgtgl5XL99OKPaj9FYZixm3LBhwx8215WDanQpKKWBbvn7QVJAmn1pRqAPtDdOaVUJH
         hCAs5A77PD6DW9GLmdIf4SDuJFCxmB0/bEaUfQWYrncC8tksbOUex2GBb6TbkEwA8nc2
         t8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhZEICrCDXLwlJHXRhIYNSI4X4GFiGMWg1GuHfipZ7o=;
        b=pAJhLqyFQmAMflbckOQ23RNz6UT7OhRz/bQXYPfvrZRh5dFXq6LmsU62Z/R0P0993y
         mpCJRMHHiuVRVPrqV5mATiY8MsS/7bXQsPRuM2/9lHV0YndwjOWR2K1gN5xICS01AuqH
         dWA6WOWDU51IZJNPK5wxRmFSSAEzKXCYRYqO8Nhd4QdipHSDouSu9BQDbg1IZ0sxHup3
         P4L9xpF554PBg9/vYdCPzwua5D7LIroW6L71xxvl7b9F/av+erlOZtTzcSx0+UwWlgj6
         A06fU9IdlOCJTyti0FJo9WuUXBCNH+eZJ7CcYd0fG6L/GjBTdt+rfqDi1XvG4+EzoNtN
         U3qA==
X-Gm-Message-State: ANhLgQ1eqXFqvtEOMLtQnqryeiVX+y94ByEz2fd4Rpnifz55wdg4EwRE
        2LTmeSlqoQFzeWtq2bhNEglvNILVFDv8PQ==
X-Google-Smtp-Source: ADFU+vtBqGc7NkH7EgsAw2HbxiEo9O/j4E7jylC0bSxQ+4gddgs8gMOmMfBDywQWvAC5Lu4KCtYBxg==
X-Received: by 2002:a17:90a:9481:: with SMTP id s1mr20352794pjo.114.1584896929957;
        Sun, 22 Mar 2020 10:08:49 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g14sm10914933pfb.131.2020.03.22.10.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:08:49 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c822193b-69d2-d90f-48dd-c6657f486d2c@kernel.dk>
Date:   Sun, 22 Mar 2020 11:08:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 10:24 AM, Pavel Begunkov wrote:
> On 22/03/2020 19:09, Pavel Begunkov wrote:
>> On 19/03/2020 21:56, Jens Axboe wrote:
>>> We always punt async buffered writes to an io-wq helper, as the core
>>> kernel does not have IOCB_NOWAIT support for that. Most buffered async
>>> writes complete very quickly, as it's just a copy operation. This means
>>> that doing multiple locking roundtrips on the shared wqe lock for each
>>> buffered write is wasteful. Additionally, buffered writes are hashed
>>> work items, which means that any buffered write to a given file is
>>> serialized.
>>>
>>> When looking for a new work item, build a chain of identicaly hashed
>>> work items, and then hand back that batch. Until the batch is done, the
>>> caller doesn't have to synchronize with the wqe or worker locks again.
> 
> I have an idea, how to do it a bit better. Let me try it.

Sure, go ahead!

-- 
Jens Axboe

