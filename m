Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105CC4E5227
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbiCWMbF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCWMbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:31:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3544839F
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:29:36 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o13so972350pgc.12
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=AR6y2GpmspFEQuz6jvd6wROyZhk41z7w9g201D/IBhk=;
        b=DQrUnR9RLmSnDoZKi8e0jVpp1Kn/21dsZzmIpimBsYT9dnAwnLqLNtitk+omyT8Sy+
         JCM6edTfUQlHG+lIitD7xJaVIh3xNyhUs0/mOeK5g+UgdM/FLDwtEsW+k1/5F9YrhNXU
         wAiklUmQEExb0dTJH3JbDbDrQ9SjDyjUB7whDBdHUVqLxbO2+Fd6L7i7q85F1HnWjj5u
         axsGIJP49JCjnSIw5fJ/VEfZBxv/aemzI1UfF+03uvWAruTSTDtagQQlufLU3yjzLWe1
         Hzju3ry+sE8921CtZim8eT/oiw8UtR8YqENTkB9J0K+nHm+LFQm9wNUPXKDyGty6imHp
         bmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=AR6y2GpmspFEQuz6jvd6wROyZhk41z7w9g201D/IBhk=;
        b=zyvVpXRkZidPDFrG0Z3Yg2eAyoge773xA3GbWTOUEBskl7yCzi1iTB78v3WxHZ0tOo
         67DaPszoTm3PqbwXr0F0aMydbOFLKH64K0GpMooz0rT77p8kizCObC11bUZQjFOu1Ea+
         QuLgcXAFgwKJ3YbQfiCp7uIMqVuiIXWGPnWO1K37Ai9uog92jXFGihPfo1yNnceQeU0O
         1blOYUwM7JXK2Y0QMUUaRHW5CUXsxzqQzvfaLKWvIaLnAIAotHNMeBKhahIO8g59Ptco
         nW3T/MFrJitFtRNwjz1cJ93A5HNNbpRIJxlZk1r4jlYlW4UYyG9ulndwp3Oz1U2S3+wG
         B3Jw==
X-Gm-Message-State: AOAM533Hn52FpxIJOz2euZ5h4BLVapxzaITIrEL7aGyzAKeu6WzREObT
        1fBHid2DWvDYeviwuc2tE5+4TWk5vLqtpEHD
X-Google-Smtp-Source: ABdhPJyZxPiffaY9YuD9aHm6jgqg0Mt2Syaon1DrDnjM/jHvwpaa5x0iREBaiMlSV32UIZIYqKyJhw==
X-Received: by 2002:a63:801:0:b0:382:a089:59d3 with SMTP id 1-20020a630801000000b00382a08959d3mr8970411pgi.350.1648038575655;
        Wed, 23 Mar 2022 05:29:35 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c21-20020a637255000000b003822e80f132sm14252121pgn.12.2022.03.23.05.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:29:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1647957378.git.asml.silence@gmail.com>
References: <cover.1647957378.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] optimise submit+iopoll mutex locking
Message-Id: <164803857464.12296.859321851786945843.b4-ty@kernel.dk>
Date:   Wed, 23 Mar 2022 06:29:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 22 Mar 2022 14:07:55 +0000, Pavel Begunkov wrote:
> This saves one mutex lock/unlock pair per syscall when users do
> submit + getevents. Perf tells that for QD1 iopoll this patch reduces overhead
> on locking from ~4.3% to ~2.6%, iow cuts 1.3% - 1.9% of CPU time. Something
> similar I see in final throughput.
> 
> It's a good win for smaller QD, especially considering that io_uring only
> takes about 20-30% of all cycles, the rest goes to syscalling, the block
> layer and below.
> 
> [...]

Applied, thanks!

[1/3] io_uring: split off IOPOLL argument verifiction
      (no commit info)
[2/3] io_uring: pre-calculate syscall iopolling decision
      (no commit info)
[3/3] io_uring: optimise mutex locking for submit+iopoll
      (no commit info)

Best regards,
-- 
Jens Axboe


