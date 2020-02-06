Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFDE15416A
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 10:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgBFJvm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 04:51:42 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44622 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgBFJvm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 04:51:42 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so3619671lfa.11;
        Thu, 06 Feb 2020 01:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zpsQw0FsMu1esZwtnhxOYwLdZDPEvW+ldzRG34WJKqg=;
        b=RZ06Iz3Wiwwxzdgrg39NMeemxzV4dUW756xB9IYXeN/ycCi3LZTQspIIa2uNC+zVkK
         Ae0/UQiioZ8yoUd56c+PzRbsXg6vYEkyrXDVJOFuVMP2OmPeA5shLzstnA2EUWj+bQcb
         Px/14ons56YBYcmzcl85WnYftSRe9GtpRSHFZKeKgNtkTRmV4BJnB7dulEarTwGolsZj
         1spMsL1IXw1hKK9+VM2GMT/V0Dh+rjfJr4srFf/+zYzfZmQ1KcHaIK4nCDRqH+xX1HVB
         VAayTR8oHCdTPrtJt+kB28ba45FNdIwM6bHyam69Kd31Rd004mMiZlpgBHWaznA3EESF
         bpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zpsQw0FsMu1esZwtnhxOYwLdZDPEvW+ldzRG34WJKqg=;
        b=MaO30y9Avey1KFkwme2KWXrh19TghdaES2H82OJWH81JaaPFvl1yt1zTVxaKkWv1BD
         mShjEBi1vtmtIepW2aY4ee3isgl0r3QoXObeUNK+PFRt5xf+6Ea0G90yWKWIvnBuHUlB
         ynZnOf6mgWARmlqQr9euNNdt5k6uVxU50gU//cHf8Ghuhe2BWf3dPfNtgJW+PUQfWVVy
         6FMdsop7lgyAIdneocYzxP9JiQoZwYPP1eNNnOoFhH5W+Xx5m6v4iIxauLDDHcYLDmdh
         3s/VRRzVhMrOVVioEYc3/5Vo95U26ZafBuVmQt93W2UQfc5QaEH1nnr5iPFf0VDfTco6
         N2Sw==
X-Gm-Message-State: APjAAAWEoHQoQ7xyvQb7O3aN2cKHV+RLuFzRu9hGbIObty0y/b5KCCcb
        bQ0GJEFKvE6xvQ8hJ8K2dfB/L1LuaqM=
X-Google-Smtp-Source: APXvYqwMLPlKASPYFiMZ3+FMwU9jZeHKiqe43kOKK2EQqcnby02DkmT09c4riaf5Lm4tUz1ww8pdeQ==
X-Received: by 2002:ac2:58cf:: with SMTP id u15mr1345559lfo.62.1580982697902;
        Thu, 06 Feb 2020 01:51:37 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id 4sm1010871lfh.73.2020.02.06.01.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 01:51:37 -0800 (PST)
Subject: Re: [PATCH 0/3] io_uring: clean wq path
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
 <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
 <8c0639c6-78ad-6240-0c18-d3ef8936e2f4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8ad4a84e-9796-6431-c73e-1d34eed0b0fb@gmail.com>
Date:   Thu, 6 Feb 2020 12:51:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <8c0639c6-78ad-6240-0c18-d3ef8936e2f4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/2020 5:50 AM, Jens Axboe wrote:
> On 2/5/20 3:29 PM, Pavel Begunkov wrote:
>> On 05/02/2020 22:07, Pavel Begunkov wrote:
>>> This is the first series of shaving some overhead for wq-offloading.
>>> The 1st removes extra allocations, and the 3rd req->refs abusing.
>>
>> Rechecked a couple of assumptions, this patchset is messed up.
>> Drop it for now.
> 
> OK, will do, haven't had time to look at it yet anyway.

Sorry for the fuss. I'll return to it later.

> 
> Are you going to do the ->has_user removal? We should just do that
> separately first.
Yes. I've spotted a few bugs, so I'm going to patch them first with
merging/backporting in mind, and then deal with ->has_user. IMO, this
order makes more sense.

-- 
Pavel Begunkov
