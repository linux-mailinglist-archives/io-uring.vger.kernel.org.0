Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D334E3F08
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 14:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiCVNCR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 09:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiCVNCQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 09:02:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C315385977
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 06:00:47 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k6so8220856plg.12
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 06:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=b5OJZPVOvvjDD2UcqMhb5SeGNQP60hg7YlWQ+Oy0yXM=;
        b=cobnNMABigzz9XvTAGJlsSPX7WMOxDJlT2/ZrQ+cpPQuTXWrhteFZdCsIOe8nWP73R
         1MN4JSzgdn21lWBTt2AuI/r6MDnsesj195Bb3B1SeHJBU+xwX5bWhC75R0ALSFTsQghF
         SamvYLI7S/5T50JXPo3XAjIassmh/hFLPZzqEVP9WQbgInO8QXRx/3+G0Myarlkj9AZM
         6uqVs/jkeHrpbpPe7PD2mEc3cQ3UPeQqvdrgXsO2+7z9UOV3gtuNDaxa318dv4jePhfs
         UndSFqZ0FP14i+Avc1vyMZxQ65YIOQ3kjM8XcsJxTpsMCw/qbKxJBDT//ptXfbaoX8rB
         lTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=b5OJZPVOvvjDD2UcqMhb5SeGNQP60hg7YlWQ+Oy0yXM=;
        b=nMjUT7YPbXqsyhue2ZO5z7W7UAhzP5kdq/v0liyJ7NGjwTjrWNjvMek0VzKp6WAtAr
         CdvrFDKV0rTu4xB55pSov1az4pADXyvSV0qeofh+UusqiRgeNrQPf+MqiF3Ru0XZ6Z5v
         xbvQnWHg+OIHpVhro80jmhVcsnYHkaNdsug1AGEn3opDbaHYzhfByusmwB4gpZTDGl4g
         W0YfBvD0CCPcfil3RqTK0/hntIBN3oYZ8UONq0FuK5j7COAAyB5fSJ3QEVbuiYmif9iS
         nRXwQnJ+P/sbVVDTdn5vhfkjAgFRLvdRT8vzDTEy4OCycGw5DMAEFo+0qLmVU6dlENS2
         h5Jg==
X-Gm-Message-State: AOAM530pdxdrwztipuP38SFnFtm/7MSdB0u6jaHFRDLAwZl08VdhZHX8
        GD36UaoSiqAAygoQgTGIUTS0vhcqLVotrDBd
X-Google-Smtp-Source: ABdhPJxE1taYfTki8s/uo0UIoC+ogLrzcB2gMEdQtOaTErsH5vC62spuxtCFy7md9rw2pK1SqSC4ng==
X-Received: by 2002:a17:902:c401:b0:154:1398:a16b with SMTP id k1-20020a170902c40100b001541398a16bmr17863874plk.67.1647954045956;
        Tue, 22 Mar 2022 06:00:45 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a6540ca000000b0037445e95c93sm17373338pgp.15.2022.03.22.06.00.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 06:00:45 -0700 (PDT)
Message-ID: <1d6cc1b9-7609-f163-6290-677274d8c1f1@kernel.dk>
Date:   Tue, 22 Mar 2022 07:00:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: bump poll refs to full 31-bits
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The previous commit:

1bc84c40088 ("io_uring: remove poll entry from list when canceling all")

removed a potential overflow condition for the poll references. They
are currently limited to 20-bits, even if we have 31-bits available. The
upper bit is used to mark for cancelation.

Bump the poll ref space to 31-bits, making that kind of situation much
harder to trigger in general. We'll separately add overflow checking
and handling.

Fixes: aa43477b0402 ("io_uring: poll rework")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1a03ba0a3cf..15c4c60decd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5798,7 +5798,7 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	((1u << 20)-1)
+#define IO_POLL_REF_MASK	GENMASK(30, 0)
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can

-- 
Jens Axboe

