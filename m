Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C09692769
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjBJTt0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjBJTtZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:49:25 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD677FEDC
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:48:45 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d4so924994pfo.4
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fYTx4XvBOSsueNyLOIdpWr5U8lWZijTLj9xr3oRSm+E=;
        b=caDtprRmnqs7qjEJ6kuMrvA/jDCyeZfB15SohMIO11wYpHzx62as+u5JQYI2u8AyB5
         Xy+Cbgas/SllQ49rHZGqZ952xfhRW8KVMEdF736i8OexY8hCfb4e1xdgsATLWS0RK4Kt
         eZT539S2+7Ctfd2bMX5zIoYvyC2VPadGHS4LvuEUrpPgAr0XkNEfzv4BZPg4cyxvJiPq
         u+dBlBtOF37BpWhhMeiqIs//A5phJdaENmeLY6IZaNxyQIbYbMujFXtSAoW3WHXjUkAm
         Aa6LgYyf2X1n6yPcFH46Q/xCsKI+wkJ/8N8J31Zl8NCUFcZ/Zsf1E1XN1JZqiw+LH00S
         YZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYTx4XvBOSsueNyLOIdpWr5U8lWZijTLj9xr3oRSm+E=;
        b=268QxbDnxIcv0x65QPTEYEh9Hig4+DDov+2ufz64TfdqRXjT41/HHEPvSjKftpIMJc
         xRoDq2kj1FYPkNDIivm7LW8kr21AtINy4PMy9C3ZNGETqpoxvwPwDFZdxP0mK44MDigw
         epydw4u/74ywibtSmi1q2k1FhFMEDY59W5Qtvmj7dRXfLKyPb15e+9mP52YpfMnyeH+D
         uwfdOpqvouF5+MermYsqvpMca6n7W1+bwiFvKijYH1jLJJO0a5CKYtE2CBNNv0AsRqW2
         3BnsVdai6O8MuPCKQqC8aseDQzOkFSfjl+XgoMz/S0bKP8l1yxDYMQFPknv9Q+1OFq1l
         jXSQ==
X-Gm-Message-State: AO0yUKUsk+CW1dllO6I9zkEtI0M7kZT9SnNdRBnWS+UrQn0MDvRhuCoV
        ZQ+eVGEtqZpPKgPlA9zoQ7JSUw==
X-Google-Smtp-Source: AK7set9l6RI7OIoQT77hlj4mEluI9EtAV/yEoHCems8NI36dW4yRIG5NRmi5GwoSrWnitnWNFBRhoA==
X-Received: by 2002:a62:86c1:0:b0:5a8:5166:ca40 with SMTP id x184-20020a6286c1000000b005a85166ca40mr6298398pfd.3.1676058463120;
        Fri, 10 Feb 2023 11:47:43 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t18-20020a62ea12000000b005a851e6d2b5sm3584532pfh.161.2023.02.10.11.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 11:47:42 -0800 (PST)
Message-ID: <8b1c3057-cc74-6169-c59a-283595eb46f0@kernel.dk>
Date:   Fri, 10 Feb 2023 12:47:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
To:     Bart Van Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
 <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69443f85-5e16-e3db-23e9-caf915881c92@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 11:18?AM, Bart Van Assche wrote:
> On 2/10/23 10:00, Kanchan Joshi wrote:
>> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
>> with block IO path, last year. I imagine plumbing to get a bit simpler
>> with passthrough-only support. But what are the other things that must
>> be sorted out to have progress on moving DMA cost out of the fast path?
> 
> Are performance numbers available?
> 
> Isn't IOMMU cost something that has already been solved? From https://www.usenix.org/system/files/conference/atc15/atc15-paper-peleg.pdf: "Evaluation of our designs under Linux shows that (1)
> they achieve 88.5%?100% of the performance obtained
> without an IOMMU".

Sorry no, IOMMU cost is definitely not a solved problem, it adds
considerable overhead. Caveat that I didn't read that paper, but
speaking from practical experience. Let's not be naive here.

-- 
Jens Axboe

