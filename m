Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341A4554F02
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 17:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359269AbiFVPWB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 11:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359265AbiFVPWA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 11:22:00 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AD83DA73
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 08:21:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id u20so1629814iob.8
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 08:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3Fp0bBjNjtMO3POp/thtmZ42VUbDhlpSIsLkMB8iASI=;
        b=iA5X4Pn1eDyf4LzOxUHVNkk2aV/rtgdIpdB14TjlEgcjghcjExbh5FkQXBFUijGi3q
         r93PequDgA9v/+JSKI5qI+HhMdE6nV/Mlt9GEPK22AMn2r76yGd6lmpKsKka4h3+xv9K
         2OzvRvu2VZWkgGF9m5mcPHr8WRHix/JiOVikZLudBKIIoyqdEB2Ww6A7sgic6ftJNclt
         5wpfTK+Efmkm+nXys3L7tWG8aiultPUkYei62oA0VNR11zYXToo5kBMBdVAzCvxhNKKP
         iuSBUHafFV3uIgR0jWmai3YMOJy7JD+eUaPwy2dehOwgzcd092BvHszH9hGBOJHj6PA3
         gv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Fp0bBjNjtMO3POp/thtmZ42VUbDhlpSIsLkMB8iASI=;
        b=CooQenPtT2BotFWjYmIYzkCLRPk0U5by2ORyn/lby45WqPcHz9OpX3pEbU3Es+rPlY
         ptWH+z7s5ThrMl1x+UYjZtGLs7nhHR+f4MlR0IpnP5rNHmFRK7YjnHrgqbNEiLCUizn9
         rlkited0hfSOU0yHMNwyaWRyQog8Y64sk2VJYgGa0jxPrT9vnFCSDyBUDH8keI9m2O72
         7iVVAbOZdnBL68JY0og7Hewx9m0gqLZ+nrqsC/ViY12FFFCyAj6KUFW4dU0/9uF4j6tq
         Yh9o8dhwOXotySz8gln0ZduZHqtla0NLC6ewB5I5bYBa+ILlcDmwm0Y4vJ2nLwvcLOhj
         HlOQ==
X-Gm-Message-State: AJIora+vrfTHC8z+MEzU+bgLWiUkmgdlfup3L1eihKA3yik/QEyZpzR7
        YGZrScL/QiST0/uO4o8tKar9RA==
X-Google-Smtp-Source: AGRyM1s0gzvPTMHIxMN6vL4kk26a/E+awBKrQU3yIfl5r99f8DaQsokDSl2fCZX4bkFZdW5JPVkqOA==
X-Received: by 2002:a5d:9bda:0:b0:668:5cb0:d91e with SMTP id d26-20020a5d9bda000000b006685cb0d91emr2085299ion.92.1655911317575;
        Wed, 22 Jun 2022 08:21:57 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b11-20020a92dccb000000b002d3edd935e5sm8880639ilr.53.2022.06.22.08.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 08:21:57 -0700 (PDT)
Message-ID: <57061b21-f31a-13b3-5311-7f250c87fd53@kernel.dk>
Date:   Wed, 22 Jun 2022 09:21:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 for-next 0/8] io_uring: tw contention improvments
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220622134028.2013417-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
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

On 6/22/22 7:40 AM, Dylan Yudaken wrote:
> Task work currently uses a spin lock to guard task_list and
> task_running. Some use cases such as networking can trigger task_work_add
> from multiple threads all at once, which suffers from contention here.
> 
> This can be changed to use a lockless list which seems to have better
> performance. Running the micro benchmark in [1] I see 20% improvment in
> multithreaded task work add. It required removing the priority tw list
> optimisation, however it isn't clear how important that optimisation is.
> Additionally it has fairly easy to break semantics.
> 
> Patch 1-2 remove the priority tw list optimisation
> Patch 3-5 add lockless lists for task work
> Patch 6 fixes a bug I noticed in io_uring event tracing
> Patch 7-8 adds tracing for task_work_run

I ran some IRQ driven workloads on this. Basic 512b random read, DIO,
IRQ, and then at queue depths 1-64, doubling every time. Once we get to
QD=8, start doing submit/complete batch of 1/4th of the QD so we ramp up
there too. Results below, first set is 5.19-rc3 + for-5.20/io_uring,
second set is that plus this series.

This is what I ran:

sudo taskset -c 12 t/io_uring -d<QD> -b512 -s<batch> -c<batch> -p0 -F1 -B1 -n1 -D0 -R0 -X1 -R1 -t1 -r5 /dev/nvme0n1

on a gen2 optane drive.

tldr - looks like an improvement there too, and no ill effects seen on
latency.

5.19-rc3 + for-5.20/io_uring:

QD1, Batch=1
Maximum IOPS=244K
1509: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3996],  5.0000th=[ 3996], 10.0000th=[ 3996],
     | 20.0000th=[ 4036], 30.0000th=[ 4036], 40.0000th=[ 4036],
     | 50.0000th=[ 4036], 60.0000th=[ 4036], 70.0000th=[ 4036],
     | 80.0000th=[ 4076], 90.0000th=[ 4116], 95.0000th=[ 4196],
     | 99.0000th=[ 4437], 99.5000th=[ 5421], 99.9000th=[ 7590],
     | 99.9500th=[ 9518], 99.9900th=[32289]

QD=2, Batch=1
Maximum IOPS=483K
1533: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3714],  5.0000th=[ 3755], 10.0000th=[ 3795],
     | 20.0000th=[ 3795], 30.0000th=[ 3835], 40.0000th=[ 3955],
     | 50.0000th=[ 4036], 60.0000th=[ 4076], 70.0000th=[ 4076],
     | 80.0000th=[ 4076], 90.0000th=[ 4116], 95.0000th=[ 4156],
     | 99.0000th=[ 4518], 99.5000th=[ 6144], 99.9000th=[ 7510],
     | 99.9500th=[ 9839], 99.9900th=[32289]

QD=4, Batch=1
Maximum IOPS=907K
1583: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3393],  5.0000th=[ 3514], 10.0000th=[ 3594],
     | 20.0000th=[ 3634], 30.0000th=[ 3795], 40.0000th=[ 3875],
     | 50.0000th=[ 3955], 60.0000th=[ 4076], 70.0000th=[ 4156],
     | 80.0000th=[ 4277], 90.0000th=[ 4397], 95.0000th=[ 4477],
     | 99.0000th=[ 5120], 99.5000th=[ 5903], 99.9000th=[ 9357],
     | 99.9500th=[11004], 99.9900th=[32289]

QD=8, Batch=2
Maximum IOPS=1688K
1631: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3353],  5.0000th=[ 3554], 10.0000th=[ 3634],
     | 20.0000th=[ 3755], 30.0000th=[ 3875], 40.0000th=[ 4036],
     | 50.0000th=[ 4156], 60.0000th=[ 4277], 70.0000th=[ 4437],
     | 80.0000th=[ 4678], 90.0000th=[ 4839], 95.0000th=[ 5040],
     | 99.0000th=[ 6305], 99.5000th=[ 7028], 99.9000th=[10080],
     | 99.9500th=[15502], 99.9900th=[32932]

QD=16, Batch=4
Maximum IOPS=2613K
1680: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3955],  5.0000th=[ 4397], 10.0000th=[ 4558],
     | 20.0000th=[ 4759], 30.0000th=[ 4959], 40.0000th=[ 5120],
     | 50.0000th=[ 5261], 60.0000th=[ 5502], 70.0000th=[ 5743],
     | 80.0000th=[ 5903], 90.0000th=[ 6305], 95.0000th=[ 6706],
     | 99.0000th=[ 8393], 99.5000th=[ 8955], 99.9000th=[11325],
     | 99.9500th=[31968], 99.9900th=[34217]

QD=32, Batch=8
Maximum IOPS=3573K
1706: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 4919],  5.0000th=[ 5662], 10.0000th=[ 5903],
     | 20.0000th=[ 6144], 30.0000th=[ 6465], 40.0000th=[ 6626],
     | 50.0000th=[ 6867], 60.0000th=[ 7188], 70.0000th=[ 7510],
     | 80.0000th=[ 7992], 90.0000th=[ 8714], 95.0000th=[ 9357],
     | 99.0000th=[11325], 99.5000th=[11967], 99.9000th=[16626],
     | 99.9500th=[34217], 99.9900th=[37108]

QD=64, Batch=16
Maximum IOPS=3953K
1735: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 6626],  5.0000th=[ 7188], 10.0000th=[ 7510],
     | 20.0000th=[ 7992], 30.0000th=[ 8393], 40.0000th=[ 9116],
     | 50.0000th=[10160], 60.0000th=[11164], 70.0000th=[11646],
     | 80.0000th=[12128], 90.0000th=[12931], 95.0000th=[13735],
     | 99.0000th=[15984], 99.5000th=[16787], 99.9000th=[34217],
     | 99.9500th=[38072], 99.9900th=[40964]


============


5.19-rc3 + for-5.20/io_uring + this series:

QD=1, Batch=1
Maximum IOPS=246K
909: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3955],  5.0000th=[ 3996], 10.0000th=[ 3996],
     | 20.0000th=[ 3996], 30.0000th=[ 3996], 40.0000th=[ 3996],
     | 50.0000th=[ 3996], 60.0000th=[ 3996], 70.0000th=[ 4036],
     | 80.0000th=[ 4036], 90.0000th=[ 4076], 95.0000th=[ 4116],
     | 99.0000th=[ 4196], 99.5000th=[ 5341], 99.9000th=[ 7590],
     | 99.9500th=[ 9357], 99.9900th=[32289]

QD=2, Batch=1
Maximum IOPS=487K
932: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3714],  5.0000th=[ 3755], 10.0000th=[ 3755],
     | 20.0000th=[ 3755], 30.0000th=[ 3795], 40.0000th=[ 3795],
     | 50.0000th=[ 3996], 60.0000th=[ 4036], 70.0000th=[ 4036],
     | 80.0000th=[ 4036], 90.0000th=[ 4076], 95.0000th=[ 4116],
     | 99.0000th=[ 4437], 99.5000th=[ 6224], 99.9000th=[ 7510],
     | 99.9500th=[ 9598], 99.9900th=[32289]

QD=4, Batch=1
aximum IOPS=921K
955: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3393],  5.0000th=[ 3433], 10.0000th=[ 3514],
     | 20.0000th=[ 3594], 30.0000th=[ 3674], 40.0000th=[ 3795],
     | 50.0000th=[ 3875], 60.0000th=[ 3996], 70.0000th=[ 4036],
     | 80.0000th=[ 4156], 90.0000th=[ 4317], 95.0000th=[ 4678],
     | 99.0000th=[ 5120], 99.5000th=[ 5903], 99.9000th=[ 9116],
     | 99.9500th=[10522], 99.9900th=[32289]

QD=8, Batch=2
Maximum IOPS=1658K
981: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3313],  5.0000th=[ 3514], 10.0000th=[ 3594],
     | 20.0000th=[ 3714], 30.0000th=[ 3835], 40.0000th=[ 3996],
     | 50.0000th=[ 4116], 60.0000th=[ 4196], 70.0000th=[ 4397],
     | 80.0000th=[ 4598], 90.0000th=[ 4718], 95.0000th=[ 4919],
     | 99.0000th=[ 6385], 99.5000th=[ 6947], 99.9000th=[10000],
     | 99.9500th=[15180], 99.9900th=[32932]

QD=16, Batch=4
Maximum IOPS=2749K
1010: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 3955],  5.0000th=[ 4437], 10.0000th=[ 4558],
     | 20.0000th=[ 4759], 30.0000th=[ 4959], 40.0000th=[ 5120],
     | 50.0000th=[ 5261], 60.0000th=[ 5502], 70.0000th=[ 5743],
     | 80.0000th=[ 5903], 90.0000th=[ 6224], 95.0000th=[ 6626],
     | 99.0000th=[ 8313], 99.5000th=[ 9036], 99.9000th=[11967],
     | 99.9500th=[32289], 99.9900th=[34217]

QD=32, Batch=8
Maximum IOPS=3583K
1050: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 4879],  5.0000th=[ 5582], 10.0000th=[ 5903],
     | 20.0000th=[ 6224], 30.0000th=[ 6465], 40.0000th=[ 6626],
     | 50.0000th=[ 6787], 60.0000th=[ 7028], 70.0000th=[ 7349],
     | 80.0000th=[ 7911], 90.0000th=[ 8634], 95.0000th=[ 9196],
     | 99.0000th=[11164], 99.5000th=[11967], 99.9000th=[16305],
     | 99.9500th=[34217], 99.9900th=[37108]

QD=64, Batch=16
Maximum IOPS=3959K
1081: Latency percentiles:
    percentiles (nsec):
     |  1.0000th=[ 6546],  5.0000th=[ 7108], 10.0000th=[ 7429],
     | 20.0000th=[ 7992], 30.0000th=[ 8313], 40.0000th=[ 8955],
     | 50.0000th=[10000], 60.0000th=[11004], 70.0000th=[11646],
     | 80.0000th=[12128], 90.0000th=[12931], 95.0000th=[13735],
     | 99.0000th=[15984], 99.5000th=[16787], 99.9000th=[33253],
     | 99.9500th=[38072], 99.9900th=[41446]

-- 
Jens Axboe

