Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E505A61FF6C
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiKGUST (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 15:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiKGUSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 15:18:17 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016C12AE3A
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 12:18:17 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p141so9845974iod.6
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 12:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bMLXf9kT6jFzurM5dejI8IHhKjdCqkkyscZJ2Jazuw=;
        b=DeEEnqUPZU+p8xGef3tLx1DEfGHAY6kETu9u8FvQyvOkkADr9ZSIqQR7eYbSkGXg9f
         Ns4FE//nH4Oeuw8AAbs+hyuctQMEc2yAe7tcDiQpDAfUA3e8m/SqgzIDutz53oRhU56r
         dZwp5IUusUwyaTOej+1O32WEsz9xeOjuSXRyoyRVqmimxvlfUtWL96QqyzjW9Hkqiewn
         OBQxs2O1+EDQoL2bkNT8aipM4hW+TztpwN0bycGmadpbYMcdt0hb2mrYYNZSMymYfuml
         U56WeQDmmoHXp7x+3TDZvJkw+GtZufrFS1O1xeh6FM+/UEQa3Fow02V8rM/c14w9XVpU
         KaEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bMLXf9kT6jFzurM5dejI8IHhKjdCqkkyscZJ2Jazuw=;
        b=B4M5wR6M+Zj/OAL41BRJEjgY4aJjapX4AKyd+UqMPX8C3VH8RN/+DLHmGDePSDd96C
         eTcPobWD/57HWXEksiIWElWE+KKABT6l988Krm3a7pCMNAgFeAeeli6NA6LmhB0h6OCW
         bHOBbwBwMm3GYQWSHUEvvCJnNw4/K8Ldv28E11vYEp6/LGxcGSA2wpgZGhRaaQkJk7JV
         l9EXEecwIVhp/i96n38x70NHwz4RCLJi6e/59sTEUZwdv8krSDdS8fazTaH/Chh5mQ0p
         GSRA2LP51hEKtOPWgG8XS1Pb9e9cUgFD4S6i5RKJRM2DwCr9Waqwvq/FewqCYG9A5CVH
         w1kw==
X-Gm-Message-State: ACrzQf0+VkdxQOdKajaBLQnQ/nHEGk501HfSKuDXR4b2L3WyMTPAeI06
        OmYwisOqQ6l/uIzzF+RQxn2hCQ==
X-Google-Smtp-Source: AMsMyM6imSfnsu6DtnWtNVBiZttSx8XEej+iZf/xMV6wsvMxxCpqmV9zoB5kkr1pX/vPZHME1gUJrw==
X-Received: by 2002:a02:290e:0:b0:35a:d680:7aad with SMTP id p14-20020a02290e000000b0035ad6807aadmr29212369jap.62.1667852296307;
        Mon, 07 Nov 2022 12:18:16 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q2-20020a02a982000000b00363e61908bfsm3090772jam.10.2022.11.07.12.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:18:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20221107123349.4106213-1-dylany@meta.com>
References: <20221107123349.4106213-1-dylany@meta.com>
Subject: Re: [PATCH for-next] io_uring: do not always force run task_work in io_uring_register
Message-Id: <166785229548.23646.1630139769240793850.b4-ty@kernel.dk>
Date:   Mon, 07 Nov 2022 13:18:15 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 7 Nov 2022 04:33:49 -0800, Dylan Yudaken wrote:
> Running task work when not needed can unnecessarily delay
> operations. Specifically IORING_SETUP_DEFER_TASKRUN tries to avoid running
> task work until the user requests it. Therefore do not run it in
> io_uring_register any more.
> 
> The one catch is that io_rsrc_ref_quiesce expects it to have run in order
> to process all outstanding references, and so reorder it's loop to do this.
> 
> [...]

Applied, thanks!

[1/1] io_uring: do not always force run task_work in io_uring_register
      commit: 462f399f87496aa71968ed863994f0db5b170ea3

Best regards,
-- 
Jens Axboe


