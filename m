Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532706BFB6E
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCRQJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCRQJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:09:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4663F241D7
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:09:54 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d13so8216418pjh.0
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679155794; x=1681747794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DLu1Yz/JXNESiV1PCDv89Y5IJkYDzuiVCrnzFMAr/Kg=;
        b=xc5m3edycz9TJ2s8NAEcWiBhN+YD0AJy4NM8dAQi1CaUFl1o5TyiBm1+cd/Mi6P+C+
         GekZiva8N+6gyMCs+uEnfrdsING4calRdr0cBC5lPoKmVCsEzf/7NDZqBJ3Q12yMyMMk
         emCxJcTPpgMFFOw/1Rq8Ua5knYfrvb/U94sLJCE+KGDOTw09Q49yaGzwIkj1LByeqbYg
         YZdKnf7vgb78/qxywQqYnk1BKHgAcgHQgQwep0i/PgV9lm4lH752leDCtu0EN+aEuy8m
         07FQoZdOXmtquPlsdZPBrVUTrkNZC9Ni6ZRXe6MBSeodE/iLlUpKIi8t0E2DUf0FXd1d
         8feQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679155794; x=1681747794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DLu1Yz/JXNESiV1PCDv89Y5IJkYDzuiVCrnzFMAr/Kg=;
        b=a9I4oecBkmP8hO8ZptowPBlWlu5I6n8fQ7aP5kameU1sqAgTPj1K6vCz9nfYUJfV9w
         +clVmqNuL9dthWy8Cq8gnR7aP1iZ76CF76SABa1mmqeraa9nXjj+HGgOMp6odTV1ARUv
         G8FuE8ZNC+0fHOe9iZS3rkczq/+TOs7o1jf0ZoYyIJUZ26bn2UtApNPK0eM9JMOq47zR
         GT8Is5XsSHeQdJL99CnsGUm5eQVNjz7z86+rCtRuewwGcVwpQaBMoDc+V3+Q1Hdfu8Fx
         90Ue40q0i1ZGzfJ02vv9jDY38pGJ/k18w6RYt27nNIWzUXoFSxjNJ5qpifen3PhW8N0A
         jlpQ==
X-Gm-Message-State: AO0yUKWc7rVfkuyiKIPGBXEHSnYxqyuZXd6WAYKUMJI/9A1MKX71JGiN
        IvjJqC8yQh6F7WxTb1iQ/beCk1T+E5kp5ljxrijQcA==
X-Google-Smtp-Source: AK7set9K1XJ1tEsr2+6+/y1ItK8YdVoPyeUdksM2bd0sAZan5frNAFu5rzChMUFuqhtoUtb9KvkwjQ==
X-Received: by 2002:a05:6a20:6914:b0:cd:2c0a:6ec0 with SMTP id q20-20020a056a20691400b000cd2c0a6ec0mr11718281pzj.3.1679155793641;
        Sat, 18 Mar 2023 09:09:53 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm3122521pjd.45.2023.03.18.09.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 09:09:53 -0700 (PDT)
Message-ID: <b3fc9991-4c53-9218-a8cc-5b4dd3952108@kernel.dk>
Date:   Sat, 18 Mar 2023 10:09:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/14/23 6:57?AM, Ming Lei wrote:
> Basically userspace can specify any sub-buffer of the ublk block request
> buffer from the fused command just by setting 'offset/len'
> in the slave SQE for running slave OP. This way is flexible to implement
> io mapping: mirror, stripped, ...
> 
> The 3th & 4th patches enable fused slave support for the following OPs:
> 
> 	OP_READ/OP_WRITE
> 	OP_SEND/OP_RECV/OP_SEND_ZC
> 
> The other ublk patches cleans ublk driver and implement fused command
> for supporting zero copy.
> 
> Follows userspace code:
> 
> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2

Ran some quick testing here with qcow2. This is just done on my laptop
in kvm, so take them with a grain of salt, results may be better
elsewhere.

Basline:

64k reads       98-100K IOPS    6-6.1GB/sec     (ublk 100%, io_uring 9%)
4k reads        670-680K IOPS   2.6GB/sec       (ublk 65%, io_uring 44%)

and with zerocopy enabled:

64k reads       184K IOPS       11.5GB/sec      (ublk 91%, io_uring 12%)
4k reads        730K IOPS       2.8GB/sec       (ublk 73%, io_uring 48%)

and with zerocopy and using SINGLE_ISSUER|COOP_TASKRUN for the ring:

64k reads       205K IOPS       12.8GB/sec      (ublk 91%, io_uring 12%)
4k reads        730K IOPS       2.8GB/sec       (ublk 66%, io_uring 42%)

Don't put too much into the CPU utilization numbers, they are just
indicative and not super accurate. But overall a nice win for larger
block sizes with zero copy. We seem to be IOPS limited on this
particular setup, which is most likely why 4k isn't showing any major
wins here. Eg running 8k with zero copy, I get the same IOPS limit, just
obviously doubling the bandwidth of the 4k run:

IOPS=732.26K, BW=5.72GiB/s, IOS/call=32/32
IOPS=733.38K, BW=5.73GiB/s, IOS/call=32/32

I also tried using DEFER_TASKRUN, but it stalls on setup. Most likely
something trivial, didn't poke any further at that.

-- 
Jens Axboe

