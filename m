Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150F25677B8
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 21:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiGETXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 15:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiGETXx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 15:23:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913F113E95
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 12:23:50 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso8285739pjo.0
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 12:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fOvY76u/F+5DB1+4Nt29/GRra8LAvkjZAKoT2ttjc6Y=;
        b=sM+s2ktrJ3WUEV3843ObCRhgUCELogS8hSIEjdgETcg5eobHN/AcwwF1OSQ2Q/ptrP
         Rar1S58gOugmlK9AO/VS3b0bRdVrzC2knfn6lScgiaxktMiyWC3tQwxNj3aXrtDjgKZy
         l1RpM3EnID3RhDOoAyIUNyFqENBsfRcIevJwADlbY2m1loXayONMTOv2Yn/T1RB1wzJm
         MuO6JeehGo36uCvq6KaUskwc+qPMyksD0bEGQg+wwPiN7oiXUTj99mi7Vh4lXYubV+aj
         OKKBW1/5rMt4YpsPr/BYgV3JHpVZaJcBXKXgoFFF5qvFuyiaPwIXkpNU5paFldLnUCnK
         j7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fOvY76u/F+5DB1+4Nt29/GRra8LAvkjZAKoT2ttjc6Y=;
        b=X/gduSgukb52i/WAICIE1zhRiVz4ULtd3ktE/Sk7HZ3/wn70rz7p6dwB3dian5iTRt
         JDDLzoiHrZ62M29mAsc5lhou/MWMjKYOhugCA/nWULVdr+woeoL6UMTggCXhf6bgBdkq
         b46qJCPjoeVDtw0A34d7vpGF3owprRtPjyPaY5s9dmaPszZc1N7bSVq+eT1hN3YMM83D
         ChM8hD+pu3e8wZ5yJO9y7jmNZ7OfhWTx2usvVswBdlClnq/NXvizt0zg3fXjVtqBG8A8
         TY1O6OY+RUrr8OSUsZLqLqMzyhhdNCaRLA/axIBPFNR37BUwpMqsOAAQ2nQMFkvGZUN1
         QznQ==
X-Gm-Message-State: AJIora84ffpEB+jiW/Jdm/ivaRFcn3JtPEXPHwDc1KUC1RpknCUPilPW
        k+H50q42mFiH54+CTlgPloYlJQ==
X-Google-Smtp-Source: AGRyM1tPZiiCIpiI6LhWolm4hxh52FUeQoVwPQ5Olrhqfc7OZ1QYhOrcRsx9wEZ0dkLPofjmXR9N7w==
X-Received: by 2002:a17:90a:1485:b0:1ec:788e:a053 with SMTP id k5-20020a17090a148500b001ec788ea053mr42177274pja.16.1657049030032;
        Tue, 05 Jul 2022 12:23:50 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a6549cd000000b0040ced958e8fsm22925047pgs.80.2022.07.05.12.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 12:23:49 -0700 (PDT)
Message-ID: <e9bbbeb5-c6b9-8d19-9593-b2c9187a5d98@kernel.dk>
Date:   Tue, 5 Jul 2022 13:23:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] io_uring: fix short read slow path
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat>
 <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/5/22 7:28 AM, Stefan Hajnoczi wrote:
> On Fri, Jul 01, 2022 at 07:52:31AM +0900, Dominique Martinet wrote:
>> Stefano Garzarella wrote on Thu, Jun 30, 2022 at 05:49:21PM +0200:
>>>> so when we ask for more we issue an extra short reads, making sure we go
>>>> through the two short reads path.
>>>> (Unfortunately I wasn't quite sure what to fiddle with to issue short
>>>> reads in the first place, I tried cutting one of the iovs short in
>>>> luring_do_submit() but I must not have been doing it properly as I ended
>>>> up with 0 return values which are handled by filling in with 0 (reads
>>>> after eof) and that didn't work well)
>>>
>>> Do you remember the kernel version where you first saw these problems?
>>
>> Since you're quoting my paragraph about testing two short reads, I've
>> never seen any that I know of; but there's also no reason these couldn't
>> happen.
>>
>> Single short reads have been happening for me with O_DIRECT (cache=none)
>> on btrfs for a while, but unfortunately I cannot remember which was the
>> first kernel I've seen this on -- I think rather than a kernel update it
>> was due to file manipulations that made the file eligible for short
>> reads in the first place (I started running deduplication on the backing
>> file)
>>
>> The older kernel I have installed right now is 5.16 and that can
>> reproduce it --  I'll give my laptop some work over the weekend to test
>> still maintained stable branches if that's useful.
> 
> Hi Dominique,
> Linux 5.16 contains commit 9d93a3f5a0c ("io_uring: punt short reads to
> async context"). The comment above QEMU's luring_resubmit_short_read()
> claims that short reads are a bug that was fixed by Linux commit
> 9d93a3f5a0c.
> 
> If the comment is inaccurate it needs to be fixed. Maybe short writes
> need to be handled too.
> 
> I have CCed Jens and the io_uring mailing list to clarify:
> 1. Are short IORING_OP_READV reads possible on files/block devices?
> 2. Are short IORING_OP_WRITEV writes possible on files/block devices?

In general we try very hard to avoid them, but if eg we get a short read
or write from blocking context (eg io-wq), then io_uring does return
that. There's really not much we can do here, it seems futile to retry
IO which was issued just like it would've been from a normal blocking
syscall yet it is still short.

-- 
Jens Axboe

