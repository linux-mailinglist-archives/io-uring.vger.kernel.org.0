Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5130A797FAE
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbjIHAaa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 20:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjIHAa3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 20:30:29 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E3B1BD8;
        Thu,  7 Sep 2023 17:30:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so319222466b.0;
        Thu, 07 Sep 2023 17:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694133021; x=1694737821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rWH+VGW4ynUEnqVgfK8Uo5vbTneevGaezyT5mB/sqg4=;
        b=OiY77u4+0lZZf05zyJjqtXsFEt53gnu17pzSAddazvgmxBSqq/iFfofB+q7WLCDEyU
         m/fz+w2DjK7ajFwh6Wl5OMnpq2lSnZxhKNITuhb+ArT10qBLF/w3E6hUYLr2Ynr9Uy0L
         sHeGcXkyahOnjrEnkCzBF3EwG9xF9KIv8UmufrGSjWBO9hDNyInV8+iHy5QYfk82jWye
         xbFkA6w68il0m14wAmbY3aZ9vJvLyqfqhwJlL2IlVpJJ69odvj++3/+rNIuFZ3ktA/po
         yf2n1Q3ML2zeCD2E+gfopvnQ7ym8KgJXlk0oJnacR9HwefsoXzYDvWgFTWYeFL/HpkjL
         rvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694133021; x=1694737821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rWH+VGW4ynUEnqVgfK8Uo5vbTneevGaezyT5mB/sqg4=;
        b=swAuNJCU2T/msM1CDytYscRXwuvHCPjssnrRg+Q6Gn7quYAY71uw8aCdr4KLss/JJi
         G6KLB7yGgMtpzSEqasgGhnoK9InCJNEld8+zIiBIk6Ib73pTZPE7X04zo7zpkugFhJci
         FB+wowcPCWOhpTjklmK7ntYr2LOzHNB4AGtrC9b25JIVYeLFsYHwRSAhkJs8WFQWvS4u
         vQxfHEgY989eWvrIeqsl/qncCGZ2RDh8vKZ5Mk2v5JpUD/f4gpCSG4bq17oZDFtAC9Kv
         wJHwZCnijNuEHfLVBXqC1a5ybSKNjL6PIh5HcP7KQEar+axr0nPLUVpqEUAJzfRRNzW3
         rmNw==
X-Gm-Message-State: AOJu0Ywbm+yLTgh3g27h3+DIFkr+l/LoZwnwZO1VTqKbEQRqI2iKTpej
        ASdAUdrtewy2vCnIWaRCJoM=
X-Google-Smtp-Source: AGHT+IHUmcSd3yGn0Yc+fxHKH36GJLlYUzap6qvtcfMqwZgOcAgDOYhbcm3dJF4+eYZ9U6PvPuYQ6g==
X-Received: by 2002:a17:907:6e87:b0:9a1:c69c:9388 with SMTP id sh7-20020a1709076e8700b009a1c69c9388mr4152809ejc.37.1694133021412;
        Thu, 07 Sep 2023 17:30:21 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id lz24-20020a170906fb1800b009932337747esm280974ejb.86.2023.09.07.17.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 17:30:21 -0700 (PDT)
Message-ID: <6489b8cb-7d54-1e29-f192-a3449ed87fa1@gmail.com>
Date:   Fri, 8 Sep 2023 01:29:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
To:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>
Cc:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
 <ZO3cI+DkotHQo3md@casper.infradead.org>
 <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
 <ZPUJHAKzxvXiEDYA@dread.disaster.area>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZPUJHAKzxvXiEDYA@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/23 23:30, Dave Chinner wrote:
> On Wed, Aug 30, 2023 at 02:11:31PM +0800, Hao Xu wrote:
>> On 8/29/23 19:53, Matthew Wilcox wrote:
>>> On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
>>>> On 8/28/23 05:32, Matthew Wilcox wrote:
>>>>> On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>
>>>>>> Add a boolean parameter for file_accessed() to support nowait semantics.
>>>>>> Currently it is true only with io_uring as its initial caller.
>>>>>
>>>>> So why do we need to do this as part of this series?  Apparently it
>>>>> hasn't caused any problems for filemap_read().
>>>>>
>>>>
>>>> We need this parameter to indicate if nowait semantics should be enforced in
>>>> touch_atime(), There are locks and maybe IOs in it.
>>>
>>> That's not my point.  We currently call file_accessed() and
>>> touch_atime() for nowait reads and nowait writes.  You haven't done
>>> anything to fix those.
>>>
>>> I suspect you can trim this patchset down significantly by avoiding
>>> fixing the file_accessed() problem.  And then come back with a later
>>> patchset that fixes it for all nowait i/o.  Or do a separate prep series
>>
>> I'm ok to do that.
>>
>>> first that fixes it for the existing nowait users, and then a second
>>> series to do all the directory stuff.
>>>
>>> I'd do the first thing.  Just ignore the problem.  Directory atime
>>> updates cause I/O so rarely that you can afford to ignore it.  Almost
>>> everyone uses relatime or nodiratime.
>>
>> Hi Matthew,
>> The previous discussion shows this does cause issues in real
>> producations: https://lore.kernel.org/io-uring/2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com/#:~:text=fwiw%2C%20we%27ve%20just%20recently%20had%20similar%20problems%20with%20io_uring%20read/write
>>
> 
> Then separate it out into it's own patch set so we can have a
> discussion on the merits of requiring using noatime, relatime or
> lazytime for really latency sensitive IO applications. Changing code
> is not always the right solution...

Separation sounds reasonable, but it can hardly be said that only
latency sensitive apps would care about >1s nowait/async submission
delays. Presumably, btrfs can improve on that, but it still looks
like it's perfectly legit for filesystems do heavy stuff in
timestamping like waiting for IO. Right?

-- 
Pavel Begunkov
