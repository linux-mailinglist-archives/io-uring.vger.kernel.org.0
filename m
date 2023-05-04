Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2B6F718E
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 19:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjEDRvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 13:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjEDRvt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 13:51:49 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C70C59FF
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 10:51:48 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-763af6790a3so5119139f.0
        for <io-uring@vger.kernel.org>; Thu, 04 May 2023 10:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683222707; x=1685814707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bmsEyvQWQLhz8Wo2w2vPqihJ7gBJNKHrPhp6n9tMN2E=;
        b=twe8mnAMI1n1ZENXvEQiP/IWTAqjuK9bihn8ytCraFymd2ek0d/gXO7PK92qlGXZJy
         K7Q0TjoPjJHO6ynWmw8JqDe1SDr7pwdV5FZgK4E9Vx6r0ad8uWNRoPU4WrHpBDvxP1ev
         cDhVRBXHZDfxtDyrtiIHlNXfxa2baPuYjTWcQ/ENtccBcuzW0Oq+jSwWU/iyQLqrzwaR
         2ZsZVKzFnAPiGkOpmvbCjnEOR8RtEAmSoQDGMSrDQgfB+c6kUXF9+Ce3s/Vw1ovmj9Lt
         CGcKP+fnizUQN1OZFqyz3MwwGGCe72Pwm8tm57h8HK20EMkUefQBHiXyZLIqEabhpBnZ
         qaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683222707; x=1685814707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bmsEyvQWQLhz8Wo2w2vPqihJ7gBJNKHrPhp6n9tMN2E=;
        b=CKUEPVeJJaFBax8MlIHsxn4nbZzoA1kXcgRf0meGDsVJczzOxaUz598eVv5LzAA8Iv
         JO0rUlYOL6OYw/4daPK4PQA3R0OjjPaqq/Eg0APUpLR62ZSqLkH+7eoi2ZzgKdhaZpkW
         Kg2Ot3xKTAMQdTMqvKTEXLUTx3Ci/d7+3JePiZO0WDTQVE4oZHxS3dwq/ZPTpagfnkvJ
         HjfbnyXtQfeU2grftSu11AhDdvW8/X8efIuxv4WN//nM7LNPDoYVqUCSIp2p5DemFc17
         BRDjKtcUqQ0v2uuKqqNAu52O6bcDZPTmZm6ztMrIdV62ZxqQZE7JQJqFoq+tJYMjw5yA
         zxjQ==
X-Gm-Message-State: AC+VfDwqe8SXPUDhyYSahQQuSv6s6rCoCe+cbOz81sBbnjLtZCBOTjHf
        rszmv5PXHW+OxIxbZK3SkZOTHtlW8+4Rdu2UM14=
X-Google-Smtp-Source: ACHHUZ7A56eBv7M/lXClJyQTCjp11K7TI6GQUUHhOUm5qb0Uiv+T2alaqH2egBBXju3lGMhMD2yWBw==
X-Received: by 2002:a6b:4115:0:b0:769:8d14:7d15 with SMTP id n21-20020a6b4115000000b007698d147d15mr4982579ioa.0.1683222707633;
        Thu, 04 May 2023 10:51:47 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x20-20020a6bda14000000b007635e44126bsm9822062iob.53.2023.05.04.10.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 10:51:47 -0700 (PDT)
Message-ID: <0a50fae3-1cf4-475e-48ae-25f41967842f@kernel.dk>
Date:   Thu, 4 May 2023 11:51:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 0/3] io_uring: Pass the whole sqe to commands
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com, hch@lst.de,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
References: <20230504121856.904491-1-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230504121856.904491-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/23 6:18 AM, Breno Leitao wrote:
> These three patches prepare for the sock support in the io_uring cmd, as
> described in the following RFC:
> 
> Link: https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
> 
> Since the support linked above depends on other refactors, such as the sock
> ioctl() sock refactor, I would like to start integrating patches that have
> consensus and can bring value right now.  This will also reduce the
> patchset size later.
> 
> Regarding to these three patches, they are simple changes that turn
> io_uring cmd subsystem more flexible (by passing the whole SQE to the
> command), and cleaning up an unnecessary compile check.
> 
> These patches were tested by creating a file system and mounting an NVME disk
> using ubdsrv/ublkb0.

Thanks Breno, applied!

-- 
Jens Axboe


