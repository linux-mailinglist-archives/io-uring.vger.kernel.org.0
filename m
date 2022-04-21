Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3B50A974
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 21:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392063AbiDUTr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 15:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392062AbiDUTr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 15:47:59 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371C1BC3A
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:45:08 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r12so6447393iod.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=1tgz+X24f6XnX4f1yXTxoEYQUjnBY33NG2UKa/wMACk=;
        b=rfKqO1m+RUvn+rJMgR7Xk6wcQBoywjMk4RP/njbPPdsig4lYlb7gHyIDwktnpEBIiC
         U+GpNV25/elY5gDks9t3mgjdkykIrlpzvzr6SFQYmYbWwVCHfe3u0+tJHnE6gRZwXgVe
         xWmvaXHPpH4OFMDVHHjqFhZ80+TWUbEihGCReMIxAlloOoVAUWw4pilRllile6vNoguJ
         zwUkUdBrpPf0OiupMaiDcuKkNMTsTIJnE0nCi8ncYulFEpayJTO9OV5or3gOEk1exOiK
         JmnEIqhOuTUdr3w9OuKOCyesCopz0Y7RQjX0Kp/sc7w2scwxXE507YgGrmQEXQBlrBqe
         5nzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=1tgz+X24f6XnX4f1yXTxoEYQUjnBY33NG2UKa/wMACk=;
        b=J+UB05c6Wew1GYdUvw35ZU0eNWQRkSSMRvPa2tPgEB5CIfigNecxK1remVSbl7k5iF
         +qAST0cn0Nmh+AoO7iIRN46raFpaVURDoVvIV82XhPQPg6A8hrzvd+SkYLF4C3urhT7b
         jJ6TuOegkiDq2wA5mH5/WXkJ7FjLWwD/g1RmRHKjdPiqvhailCDmk+zkRt6J5e40N0/s
         gDmI6qkTNYHpk40P/+7SA92PQoKGBopZft/6pzoF3f/kSvjdbhE+U+u/NZDuakaRolJW
         nmUKCY6ATH4cj5ZzFfuxUSN2LmKwbz2EQurmySM//jnxtEIV4Y+h7FHC7cUzqzi3d0GR
         PCLA==
X-Gm-Message-State: AOAM531cKfRl1q+xYV4ZD1oUVY4WI5/75mrZXUX8ivSc3SUUYlBm7jfw
        Y1IWOm2OSesZPwWyRE9Jc6+slA==
X-Google-Smtp-Source: ABdhPJxnmjYyEBvl3tBa4XmCQ75rxDL2W5WvAVzWXw/AvNBhlAe7CyRBsApwpMMayd0C/pfomXn15Q==
X-Received: by 2002:a05:6602:2dcf:b0:656:d2f8:9dee with SMTP id l15-20020a0566022dcf00b00656d2f89deemr576107iow.29.1650570307512;
        Thu, 21 Apr 2022 12:45:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z18-20020a05660229d200b0064c719946a8sm15215671ioq.34.2022.04.21.12.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 12:45:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
In-Reply-To: <20220421091345.2115755-1-dylany@fb.com>
References: <20220421091345.2115755-1-dylany@fb.com>
Subject: Re: [PATCH 0/6] return an error when cqe is dropped
Message-Id: <165057030672.167153.10167028049673775527.b4-ty@kernel.dk>
Date:   Thu, 21 Apr 2022 13:45:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Apr 2022 02:13:39 -0700, Dylan Yudaken wrote:
> This series addresses a rare but real error condition when a CQE is
> dropped. Many applications rely on 1 SQE resulting in 1 CQE and may even
> block waiting for the CQE. In overflow conditions if the GFP_ATOMIC
> allocation fails, the CQE is dropped and a counter is incremented. However
> the application is not actively signalled that something bad has
> happened. We would like to indicate this error condition to the
> application but in a way that does not rely on the application doing
> invasive changes such as checking a flag before each wait.
> 
> [...]

Applied, thanks!

[1/6] io_uring: add trace support for CQE overflow
      commit: f457ab8deb017140aef05be3027a00a18a7d16b7
[2/6] io_uring: trace cqe overflows
      commit: 2a847e6faf76810ae68a6e81bd9ac3a7c81534d0
[3/6] io_uring: rework io_uring_enter to simplify return value
      commit: db9bb58b391c9e62da68bc139598e8470d892c77
[4/6] io_uring: use constants for cq_overflow bitfield
      commit: b293240e2634b2100196d7314aeeb84299ce6d5b
[5/6] io_uring: return an error when cqe is dropped
      commit: 34a7ee8a42c8496632465f3f0b444b3a7b908c46
[6/6] io_uring: allow NOP opcode in IOPOLL mode
      commit: ebbe59f49556822b9bcc7b0d4d96bae31f522905

Best regards,
-- 
Jens Axboe


