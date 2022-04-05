Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82624F51D5
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444680AbiDFCVS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457405AbiDEQDL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 12:03:11 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69772AC45
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 08:40:51 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id x4so15605937iop.7
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SHfmQ1kJdNO2kkSn9puZ+tx3OduiqCzYa9UflCPowkU=;
        b=XriHKiEYmgcnCAm/NJv70Z19tG9tVczVNnXbqhGT5cKXfhju3CeMzd8LpZkP/43sNc
         Ns/b+3oCUENC8zbq1WRl5myylvShSEk9A7DhDMoDAlnwhdMk+Gldd2bN7XpGDkJlyBXO
         //ewe4xnJH5aJQUI81sD5cPbZOlgkno/OUE01TV/I8aRuNo56FzA9tWiWNCATg53sQId
         baZVzB3x1f5Jw0wSAalnnWMeGBoZp8Y+Hbmfmf0j9NGQ0CqKKp3juUYeynxnKB9v5Xio
         ZEKhwbmrCZ01iSXNBK0fsWFDnHRLD6rl9NXN2ATkq9SQ6z3o4F/CJ8kIIoROW54QKcdD
         Stlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SHfmQ1kJdNO2kkSn9puZ+tx3OduiqCzYa9UflCPowkU=;
        b=F7jGz/uXMOvmr2atjlhQczsCEptjqpFom9H6fIYXQbRh6g1R3s6vhEbq6A2tNMvQ/N
         ZfE65V6iHq8YglcPALgD6Fk9hq+ORvWLW+fUan4KAu9FaEAqSS6k6sxpm7lHvjTC8ggm
         UTo0CezeZFD2Ixf+inER817ZH0EFuF95W1J2ZBNf2TzWZ36tOo6Xx9gEcF0++q+gjl1c
         NbOv4BC+7VJyeGBhgjsUiNYtquOT6Gi7ZkTbOZYJ6ILf8Q1v632O33IDHE9ayvm+W+yy
         U95GXHoc3f/CWMaO9lS7/cYbiFPjQNgR75hmti6IFzdkDqwEyUOOOdoViRnUD6cEnOFA
         YrkQ==
X-Gm-Message-State: AOAM53363qnzGATIrbwtMa+Fti6CY5qdMFKmx1w9o4FvoIaB3RUmNS52
        LmzAeSLPMuQZEOH4nR+OL++NTw==
X-Google-Smtp-Source: ABdhPJyBLjmYq20oBQVKQx2jlXPdOSgx20dhiha+1hLzhSfFmg59nY5XRVnCOYYDtlNFnwGW18ZkEA==
X-Received: by 2002:a05:6638:2611:b0:323:be52:bb0e with SMTP id m17-20020a056638261100b00323be52bb0emr2400345jat.232.1649173251259;
        Tue, 05 Apr 2022 08:40:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z12-20020a92d18c000000b002ca3ac378e2sm3926799ilz.76.2022.04.05.08.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:40:50 -0700 (PDT)
Message-ID: <51171191-943f-b9e4-b78b-674834de00b1@kernel.dk>
Date:   Tue, 5 Apr 2022 09:40:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220401110310.611869-1-joshi.k@samsung.com>
 <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
 <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de>
 <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
 <20220405060224.GE23698@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220405060224.GE23698@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/22 12:02 AM, Christoph Hellwig wrote:
> On Mon, Apr 04, 2022 at 07:55:05PM +0530, Kanchan Joshi wrote:
>>> Something like this (untested) patch should help to separate
>>> the much better:
>>
>> It does, thanks. But the only thing is - it would be good to support
>> vectored-passthru too (i.e. NVME_IOCTL_IO64_CMD_VEC) for this path.
>> For the new opcode "NVME_URING_CMD_IO" , either we can change the
>> cmd-structure or flag-based handling so that vectored-io is supported.
>> Or we introduce NVME_URING_CMD_IO_VEC also for that.
>> Which one do you prefer?
> 
> I agree vectored I/O support is useful.
> 
> Do we even need to support the non-vectored case?

I would argue that 99% of the use cases will be non-vectored,
and non-vectored is a lot cheaper to handle for deferrals as
there's no iovec to keep persistent on the io_uring side. So
yes, I'd say we _definitely_ want to have non-vectored be
available and the default thing that applications use unless
they explicitly want more than 1 segment in a request.

-- 
Jens Axboe

