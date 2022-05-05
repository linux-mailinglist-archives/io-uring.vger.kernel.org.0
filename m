Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4CC51C80E
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 20:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiEESkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 14:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385218AbiEESjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 14:39:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263A160ABB
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 11:29:30 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so4698587pji.3
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 11:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=qJDsBNaU0WtP3zGJAVGJc1XV1UGinZSSPR/pmXCT3fg=;
        b=MsfJI7wgJazaq5lFNIqyg/2hjMk8meBjzjrd37sw7/Yk7hKbq6mcHgHKyfNrzPrwpo
         0E1Rhuc4JhEujqO3Ymm23DCQb1xvZhdoYQeeH+XZVHL1soFc+SIj43noHv6Iy8jJGrZF
         sh/+BF52lPIHxSSD0OLbL2P8hDReNZAUe/tmmvkUFfLQmKVNzbZP38QmNZXhrU+cy72m
         52jkMVElSfjXcglvj6sKvuLxDlZCb5KBH9dMTxZPfZSUn45mMeDk/RphA3UbmnpfW/3n
         KegiPP91o1WbPuGBlYgwClPlgjyMZJecmcGFZhwF7/JWNOflDDtINsW2zLF48xa8I5+y
         HXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=qJDsBNaU0WtP3zGJAVGJc1XV1UGinZSSPR/pmXCT3fg=;
        b=Xl64KZW0wOC+Vsp9GEw7bbrL02BKWlyIbDMBEII9FLgTf1L4N4YJhiW4iRcP5dcms1
         8iLUZWot5Ue9zJjMNOCmCwZS+tx76LuAOGdg0N4v0ATyK0kQFDyHOcpitdg99mjRddpy
         ZbyDGS/5iQ5S4YMuVjn59ScOH3RjO5wIurcZnzPOHSkFhAYO05NnveEkGOs55xTMTBmq
         LJ6n2mL7ID8Gsr6ry5n1wqWBPsAtHgJuY4c0NhBpqGYNcwRdAr3Y9XhXaF69opTdTv3z
         4hO93ncna+I8S+mbAcC7jekOzEm9w1pfL56Fi0/s0NngAuwIQjLyOavf8AvZC01BBmHZ
         i+Sg==
X-Gm-Message-State: AOAM532nf9SISAyS9+BCuTHrNzH2jAWUPm4QDN5kI2b3hvEvrnWjtUBB
        k/fm2b38VoajfapxEMOwmXKWGQ==
X-Google-Smtp-Source: ABdhPJzkMXHdKGEICRUdE4gyAEM++LbBaogm7oaZDoNke0R5SMMnkNorn/rvTJeSWr6sGKgr+fDWxw==
X-Received: by 2002:a17:902:dad2:b0:15e:9faa:e924 with SMTP id q18-20020a170902dad200b0015e9faae924mr23518649plx.94.1651775369465;
        Thu, 05 May 2022 11:29:29 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e14-20020a17090301ce00b0015e8d4eb1d3sm1934883plh.29.2022.05.05.11.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 11:29:29 -0700 (PDT)
Message-ID: <a715cc61-97e7-2292-ec7d-59389b00e779@kernel.dk>
Date:   Thu, 5 May 2022 12:29:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
 <20220505060616.803816-1-joshi.k@samsung.com>
 <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
In-Reply-To: <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 12:20 PM, Jens Axboe wrote:
> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>> This iteration is against io_uring-big-sqe brach (linux-block).
>> On top of a739b2354 ("io_uring: enable CQE32").
>>
>> fio testing branch:
>> https://github.com/joshkan/fio/tree/big-cqe-pt.v4
> 
> I folded in the suggested changes, the branch is here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
> 
> I'll try and run the fio test branch, but please take a look and see what
> you think.

Tested that fio branch and it works for me with what I had pushed out.
Also tested explicit deferral of requests.

-- 
Jens Axboe

