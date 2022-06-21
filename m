Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF1F5535BD
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 17:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352610AbiFUPRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 11:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352626AbiFUPRX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 11:17:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678BDA2
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 08:17:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m14so12822810plg.5
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 08:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=0ysdHn8y2RTiYf/f0JpzP2GyHjJbUUaOnlJokEgE3hk=;
        b=YFKoggdSISdtNDXko6ANUnIvFHpZrJ3tQldTX5GixYkJ2xMZHg5JAgbIvIyIaWNwa4
         3A/kEaFycuvOmLlkev2qHgtjS/Qn4CXWyun3Hdzw8MfZXc4WEfvO2CX6TKs9FWOL3BIF
         eq+gHzYlcfZ+hoAV/+Itqji3A1gRYQVgBX9LesQt9/QwNUVQOsORZmgzd6ahQMDI2pLY
         6wgBw7piXciCYK6tQZ9m8iVbuHfvFk27sPCizqU6MHi8vSDFcN7LGphZEXvxFs/e5tB7
         Iv9Suu83ZR3/8uG1W3mOp1hUrjsDKhmsBPeu9v2ADU0LPbnDDWYngCOhEN2T2gZSZAZ2
         sDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=0ysdHn8y2RTiYf/f0JpzP2GyHjJbUUaOnlJokEgE3hk=;
        b=pVqeumGY7C8CCAtPOYZDWYtX7OlBMkewyz5BUmlaZSMeBRvmzdTm3ELqA+6/fuvozb
         DSnSjNOT4JlFO8lTXQDfLunluIXF1PDBjHE+4VG2SsKeTOSenDPnFPpeCEKf1l5goYjo
         OM3McLQFXkhGl3G3aiK3xGdvZGdIuU65Zvs1N6exjIaq4fx7loJfGo5Fl+YXttlkjQxM
         gAEKQHSQVYznl3deq8F/NL48Er0VW9YqEm+VTKxFEZ64ySw9/OWv6xuXFE8UvZkyuu2D
         20Ut55hN6flluMAZRBkRGtzxlKj/lhrEXu+LDYGg6dVlSbs1B8tH/rGBoFSA/cBQ5Q82
         UPyA==
X-Gm-Message-State: AJIora/wBIAj5qgr42DIehF7zvyhu/UeVLQ2UOKNVp82q9DHUJ0OziC8
        ZGFBF5pk8l3ihOBqileE5Z1HN6Wzc7IAZw==
X-Google-Smtp-Source: AGRyM1sxoGDg76t3x5RADkeD7ISpU24ZwFvLvwBY2k32AJ+QdX+KxpmNS8YZ4qQrfNRqyXg0SV+AhA==
X-Received: by 2002:a17:90a:6809:b0:1ec:c213:56c8 with SMTP id p9-20020a17090a680900b001ecc21356c8mr6244939pjj.82.1655824639156;
        Tue, 21 Jun 2022 08:17:19 -0700 (PDT)
Received: from [127.0.1.1] ([2620:10d:c090:400::5:36ac])
        by smtp.gmail.com with ESMTPSA id y1-20020a63ad41000000b003fae8a7e3e5sm11109892pgo.91.2022.06.21.08.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 08:17:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655802465.git.asml.silence@gmail.com>
References: <cover.1655802465.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] random 5.20 patches
Message-Id: <165582463821.2653970.10576068254185509144.b4-ty@kernel.dk>
Date:   Tue, 21 Jun 2022 09:17:18 -0600
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

On Tue, 21 Jun 2022 10:08:58 +0100, Pavel Begunkov wrote:
> Just random patches, 1/4 is a poll fix.
> 
> Pavel Begunkov (4):
>   io_uring: fix poll_add error handling
>   io_uring: improve io_run_task_work()
>   io_uring: move list helpers to a separate file
>   io_uring: dedup io_run_task_work
> 
> [...]

Applied, thanks!

[1/4] io_uring: fix poll_add error handling
      (no commit info)
[2/4] io_uring: improve io_run_task_work()
      (no commit info)
[3/4] io_uring: move list helpers to a separate file
      (no commit info)
[4/4] io_uring: dedup io_run_task_work
      (no commit info)

Best regards,
-- 
Jens Axboe


