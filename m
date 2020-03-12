Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A801830C1
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2020 14:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgCLNAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Mar 2020 09:00:02 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34872 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCLNAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Mar 2020 09:00:01 -0400
Received: by mail-io1-f67.google.com with SMTP id h8so5571586iob.2
        for <io-uring@vger.kernel.org>; Thu, 12 Mar 2020 06:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LitzFk/A1AbzzBL8sbUmEvF7Mbyll9ULEY7M/Zdpq10=;
        b=0uxPzv5t27xjHSG1CTRWIK0+lIMey7DwWxfsgx54j0cUFuaQgqe7cHrp4PpU1OMKLj
         1zxkZDAtdMahZ19xGdQFqQUeRjNY2vw1/l2Y0S0HdnOgBQcVZ+Hi690aNZwr7EXz0EW3
         O+6/26OeSXxLPnynwMjM/Saa3MUhmBOhNPHIvp1kGRXUwclH0bfLNcdyAxF3GaC+WVeO
         3auuE62dIOnpXGb/uQFI9aUK0LDGw+C5SWo7u4YsrmAHSVb4c+Py3xV9RX1q1O8nznlj
         FJdCPeGKwvSWBS5QQagIlbS5M91sSSmoNw2Qhs+qx9jlrmvfBqaP619nBsofwkhM4sDO
         ZIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LitzFk/A1AbzzBL8sbUmEvF7Mbyll9ULEY7M/Zdpq10=;
        b=jEBNoeJIRwm01ajVn5M1quMvRpSCMBpKpV6OxWs3Oe7ECla11uRrTj+vpFaQRRxJSS
         VJvaqXModiaoifBOJbahoUYkZGLrrANv3UshagI10rwZChTEraoGpXYZ3xzhrLb2xY8E
         ZHa9Hga9eNm8jJQbG6bU6t095FRhylYkUOPMCeEnZdqvu/MrXi3M9Ge6Ir5PmJu3a+De
         XYpHy+xpcCAlQrHAmftaSOhb/xyEi6HAfpXZu47nySdrbnmtOjxVC37c2A58ox6RPRbR
         InmLHZndNsI8n/jq94armTQ3fFMjpx8Pr6a9e+1IyntkldxnClHAJUg8nz2YtMqBFcDv
         0BTw==
X-Gm-Message-State: ANhLgQ1gcwp53YqpW7KLoyTIS+NoLtMvZtksNxdEQj0nuuVH5LLGCVI+
        iEGk+bfESH18DgfgJddDCPkVQ9koxA82lQ==
X-Google-Smtp-Source: ADFU+vv2BjLiR0oYnibrWiS1FDUBgRL8VVb/hrf9ahIOaB5qk/sCOjUVkDRdfvOxSoGkQH3WgfgnxQ==
X-Received: by 2002:a5d:9dcf:: with SMTP id 15mr7629560ioo.105.1584018000631;
        Thu, 12 Mar 2020 06:00:00 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t24sm6424036ill.63.2020.03.12.05.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 06:00:00 -0700 (PDT)
Subject: Re: [FIO PATCH] engines/io_uring: delete fio_option_is_set() calls
 when submitting sqes
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200312111617.7384-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b4f06b8-0a19-ef19-7700-769b3159e388@kernel.dk>
Date:   Thu, 12 Mar 2020 06:59:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200312111617.7384-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/20 5:16 AM, Xiaoguang Wang wrote:
> The fio_option_is_set() call in fio_ioring_prep() is time-consuming,
> which will reduce sqe's submit rate drastically. To fix this issue,
> add two new variables to record whether ioprio_class or ioprio_set
> is set. I use a simple fio job to evaluate the performance:
>     fio -name=fiotest -filename=/dev/nvme0n1 -iodepth=4 -thread -rw=read
>     -ioengine=io_uring -hipri=0 -sqthread_poll=0 -direct=1 -bs=4k -size=10G
>     -numjobs=1 -time_based -runtime=120
> 
> Before this patch:
>   READ: bw=969MiB/s (1016MB/s), 969MiB/s-969MiB/s (1016MB/s-1016MB/s),
>   io=114GiB (122GB), run=120001-120001msec
> 
> With this patch:
>   READ: bw=1259MiB/s (1320MB/s), 1259MiB/s-1259MiB/s (1320MB/s-1320MB/s),
>   io=148GiB (158GB), run=120001-120001msec

Thanks, in hindsight that was pretty dumb!

-- 
Jens Axboe

