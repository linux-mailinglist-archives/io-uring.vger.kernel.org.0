Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB9D72A125
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 19:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjFIRW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 13:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjFIRWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 13:22:16 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D1518D
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 10:22:14 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-77ad566f7fbso17114439f.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 10:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686331333; x=1688923333;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYIeMkwmKuB9JmHvSC42RlCVaNg15x4QTditd5jnaZM=;
        b=SjjmE2qX/PKmGUHgWYZ3jmJMd1t4FxBaxUB3LOJWoU4VNMWmDCBz0V/vqfHgFvD65z
         cwpdn2OEhjHzeTICwQ7O9BBZEIQJNbnS2YQrHxVcuyMpvZiNcJrQa1c/hWBmWyJuMpKi
         idrI19bt6esHoW/Xj2WtAsZMh9eNGoL1Y/JJ0lW03PUB6vdxTMlnxOjTgyv6EDPK6+Er
         CmzU58kHFDeyow+6IeG0DPZoLN0laiV7mWrkdUrec93kQ3Uz6vqPhrIfGU7vMPJOSLy1
         /GmFsxH/s3O2ZDWNctqOQsCX2WhuYRR1U2UWQpPXlET7mDnUWnsHRYn255qrKhJMv608
         LlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686331333; x=1688923333;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VYIeMkwmKuB9JmHvSC42RlCVaNg15x4QTditd5jnaZM=;
        b=QLpIrfDUOs9ouCNjcVuyndgdRhpV2RLsmUv2dbEDsz9uwgnZsU4O9hT4N2HIvICq3w
         5eJ/RKKzBS9ICzk1gtnebaxg6B+qkVP01Jnq2gXWSlmfnjb478UwmCr4Yetb59jpg6JN
         C27rfNTokLbMOGdhXF4OnRuTIrvaxatrqrZin2YIrCfOPjWQer0wNLIMR/PVhVz3c5dB
         nZsk0GbyO0PV8JPVdfFILEYtdrKykp9cH7Zq3sQlrzbb2blT3o3UL5wb2fJbhlgRwIsi
         hV4C+G8uopNLrZQO4s4H9BX7cP0kP0W89LaAyaDhs8MZHiF1DV6UFuBe50EvIuh/ssC9
         fOfw==
X-Gm-Message-State: AC+VfDy61VKvQ9+0KIhvx88CVLNENZnAaC6bZ7rq5iRTncwO2Rw4NSKD
        mUkTomJ7iafvHjp/tMuSnG0JnzGHuX85oB2ThGw=
X-Google-Smtp-Source: ACHHUZ5Wc4yeKI7/Td2jd0OQXIcwnRDb3oDZO+C6F92c9mDDzfusbXv0auvF/i8o3EQP1h91Txf+hQ==
X-Received: by 2002:a05:6e02:1a2c:b0:338:4b36:5097 with SMTP id g12-20020a056e021a2c00b003384b365097mr1688518ile.1.1686331333422;
        Fri, 09 Jun 2023 10:22:13 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0040fa0f43777sm1048216jao.161.2023.06.09.10.22.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 10:22:12 -0700 (PDT)
Message-ID: <e81bde59-6674-ad10-d0d2-7a4f2b87c19d@kernel.dk>
Date:   Fri, 9 Jun 2023 11:22:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: liburing 2.4 released
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

Hi,

Happy to announce that the 2.4 release has been tagged and pushed. Time
to get those distros updated!

The main changes in this release are:

- Add io_uring_{major,minor,check}_version() functions.
- Add IO_URING_{MAJOR,MINOR,CHECK}_VERSION() macros.
- FFI support (for non-C/C++ languages integration).
- Add io_uring_prep_msg_ring_cqe_flags() function.
- Deprecate --nolibc configure option.
- CONFIG_NOLIBC is always enabled on x86-64, x86, and aarch64.
- Add support for IORING_REGISTER_USE_REGISTERED_RING and use if available.
- Add io_uring_close_ring_fd() function.
- Add io_uring_prep_msg_ring_fd_alloc function.
- Add io_uring_free_buf_ring() and io_uring_setup_buf_ring() functions.
- Ensure that io_uring_prep_accept_direct(), io_uring_prep_openat_direct(),
  io_uring_prep_openat2_direct(), io_uring_prep_msg_ring_fd(), and
  io_uring_prep_socket_direct() factor in being called with
  IORING_FILE_INDEX_ALLOC for allocating a direct descriptor.
- Add io_uring_prep_sendto() function.

and it contains all the helpers you'd need for the 6.4 kernel (when that
gets released). As usual, any liburing release will work with any kernel
version.

Thanks to everyone that contributed to this release - either directly
with code contributions, or through testing and reporting issues.

-- 
Jens Axboe

