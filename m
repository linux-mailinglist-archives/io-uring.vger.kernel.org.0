Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8227D0E51
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377034AbjJTLWJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 07:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377058AbjJTLWI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 07:22:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2891A8
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 04:22:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c9d132d92cso1088365ad.0
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 04:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697800926; x=1698405726; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4rTFX0HePMxmm59yWtqEmi9jCOfTug26aa9CcqvS4Do=;
        b=dacdo/bjGQLCl9FUmncLAZZfty5T7jXkBD7FYMA70VxtrR81ZFjn0cViweR2c+CNXg
         /ShR5yNie9A4Bd869RcUYRmjiOMAZISDSCBDBAl8LBz/8dckkrGjnuz5K39/8ZHFZiaJ
         6vdCXSXryoSyMPeOrtv4TgQnuUB8HBfqKzF/NKswCxkI1IjlweD01NSL/uFBkiLhB2m3
         rtR5H6ci1jM1Qn0QwrGC7luBfBI4fw5u09Y93k1O6Rr5V3UqLm84qyIVqtdKE7wZexbU
         HDKBGzJZrbbpsw2XaU1/3BpKd31e14WUJlNM8saABm6EgGiKVxtBXWhO38HPJqiP0PuR
         xYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697800926; x=1698405726;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4rTFX0HePMxmm59yWtqEmi9jCOfTug26aa9CcqvS4Do=;
        b=dqGBVDYcMhwVP1kCRjXuLdelQ0fyQIurxKjw9ad6723LAQXrRhquYPJO2gvaJQhSid
         ctuQPoncZ22wUQbj1kMD5VVYaCYdWA+N5REDd8aSWGijfUAJR9QUi5oOnnJ3TW3y9WKT
         ASQf7Lyem3SMh4CEBdxotltbe0e2vSM4R/duuEcqkQsZ3JDNHw1JgXcjMCRljqkBzanu
         9odKmAqblFsswnImHmnJggTA7yjCw9gjUJc+pKPB/vBbT6NGK2HXR9x3IQMCMbdutNTP
         H610BdhrjOF9aSFBMSb7SQwDQ3MwaRoeaRDjJnY4p94hAd4JIq5j8dMXKEDqcrYPpUK7
         BDKg==
X-Gm-Message-State: AOJu0Yxx+71OrCYtF53xJmSL4zxGmGw06FpBoYiL3d7GcV8y+lT0fQAj
        08dD3B980+liB2BSjf28+oc9NZ0Z4jmAkTkurvjBdA==
X-Google-Smtp-Source: AGHT+IEtvLDc/sZbubY9IzWMmcjyalebWY2EVhxYcwWS//sppi7kcLwfB4Trt1/Fkhh2/J8ZCfyBXw==
X-Received: by 2002:a17:903:23c7:b0:1c6:9312:187 with SMTP id o7-20020a17090323c700b001c693120187mr1528876plh.3.1697800925876;
        Fri, 20 Oct 2023 04:22:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id je17-20020a170903265100b001c728609574sm1311723plb.6.2023.10.20.04.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 04:22:05 -0700 (PDT)
Message-ID: <9ca5fb73-74c5-40f4-9107-0d3b406fd9c7@kernel.dk>
Date:   Fri, 20 Oct 2023 05:22:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.6-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix for a bug report that came in, fixing a case where
failure to init a ring with IORING_SETUP_NO_MMAP can trigger a NULL
pointer dereference. Please pull!


The following changes since commit 0f8baa3c9802fbfe313c901e1598397b61b91ada:

  io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls() (2023-10-05 14:11:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-10-20

for you to fetch changes up to 8b51a3956d44ea6ade962874ade14de9a7d16556:

  io_uring: fix crash with IORING_SETUP_NO_MMAP and invalid SQ ring address (2023-10-18 09:22:14 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-10-20

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix crash with IORING_SETUP_NO_MMAP and invalid SQ ring address

 io_uring/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
Jens Axboe

