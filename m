Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43AB5517D2
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 13:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiFTLwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 07:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFTLwp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 07:52:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0108817585
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 04:52:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so901367pjj.5
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 04:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=m02wMB0prAWJUs80c+SmQba94NqR6F8iqaqImzhVl+g=;
        b=2WuSby5zdcHuBAoB5tNvNMw1RnJ27dYPihlp2cQUkpMocVn1omzk/UGjdIW0fVk68e
         0fwCuXgHHCEEcoaDKqpYKhYk3oy5GrbzLnNY9xr7pGCs9vM/iRoMO+X/WxsrlS0Q+PXq
         hbUOrPWcMAZ+A8Q5mSQoqc5m8r8J8RxhQcFeqVYxnA7cOe0W5Bj80R36dRGk36NiztYw
         48TdRpGt2Rg56q0Sb7CbGLaga9NS+BQeITtqozPcIkPsoI0b1xZ1PO3vOwZbx/eDABbe
         bkwfdIUpaEqcXvvEeSLh8kHE+z5I2uRpwyYhIOSJ2x/HwCRkmHVscirC8yudtTzS3t47
         vWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=m02wMB0prAWJUs80c+SmQba94NqR6F8iqaqImzhVl+g=;
        b=Re5nNLwA4/FukzI3v1HwyVKjAeH7A1iRsaKoicgz67qkFLReDRQcS1DMtyfKRy8Q4C
         jGPwlpHcdIs50vIRJRd8AJedvmC9dQp9i24ATWme/erdJlbETMUA30z4Ub35R6Gp8NMf
         Jxw3bUYaLBoNknJOP4t+vo3sv/cYvRLovO0CQS6Q/DuWSUsfvcgFz1ywXwD6Gl8ENCBd
         +ZVVjdQXmUb/zGzCedfbO4W6tbDTb3mO/TWM3pGW9GxfJG510ZJRiv1Ui8qC57lUMhL9
         c2T+dao33IyJOoYy7NdtSgveNyfqzP0kD4XCri4QL6MhfKf1kSkk7iRGb6DIlC1oBrty
         hJxA==
X-Gm-Message-State: AJIora/KFsfWtXedbJNvz3EZadFAr2xaLI/W82GTBlDkHIj4DowDYRD/
        760k4gdfe5RQ5B3A7EH/yhM1dGlv71YTqg==
X-Google-Smtp-Source: AGRyM1voMiedNd4xKhVPYaICeiQ9nwNsL+MFjPVuR+yMPAfH30jbJ5CKohgWGz0HysUZDw3FjMp+gQ==
X-Received: by 2002:a17:90b:350b:b0:1e8:5177:fe7d with SMTP id ls11-20020a17090b350b00b001e85177fe7dmr38000659pjb.142.1655725963214;
        Mon, 20 Jun 2022 04:52:43 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020a637418000000b0040cdc508087sm636127pgc.19.2022.06.20.04.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 04:52:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 00/10] 5.20 patches
Message-Id: <165572596253.2011131.4576214447049708379.b4-ty@kernel.dk>
Date:   Mon, 20 Jun 2022 05:52:42 -0600
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

On Mon, 20 Jun 2022 01:25:51 +0100, Pavel Begunkov wrote:
> 1/10 fixes multi ring cancellation bugs
> 2-3 are cleanups
> 4-6 is a resend of the dropped patches
> 7-10 are rebased cleanups
> 
> Pavel Begunkov (10):
>   io_uring: fix multi ctx cancellation
>   io_uring: improve task exit timeout cancellations
>   io_uring: fix io_poll_remove_all clang warnings
>   io_uring: hide eventfd assumptions in evenfd paths
>   io_uring: introduce locking helpers for CQE posting
>   io_uring: add io_commit_cqring_flush()
>   io_uring: opcode independent fixed buf import
>   io_uring: move io_import_fixed()
>   io_uring: consistent naming for inline completion
>   io_uring: add an warn_once for poll_find
> 
> [...]

Applied, thanks!

[01/10] io_uring: fix multi ctx cancellation
        commit: 45987e01342c884ff15f180e1c5f3bfc6d5ee50f
[02/10] io_uring: improve task exit timeout cancellations
        commit: 23641c3094a7e57eb3a61544b76586a4e2980c2d
[03/10] io_uring: fix io_poll_remove_all clang warnings
        commit: e67910197b4844701d17439ab867ab8a08425ce6
[04/10] io_uring: hide eventfd assumptions in evenfd paths
        commit: 8ac9127be60bf7de7efcee71bba0fd08bb3573fd
[05/10] io_uring: introduce locking helpers for CQE posting
        commit: d88cbb474bb52fcced34e5ebc47de4521f98713f
[06/10] io_uring: add io_commit_cqring_flush()
        commit: fe435d183d95618149aedd19c4ccf141ff74b875
[07/10] io_uring: opcode independent fixed buf import
        commit: a708de4e48daf9e667f9e9a983c3a432614202ba
[08/10] io_uring: move io_import_fixed()
        commit: d9b631c2d3d437792d1cdb9576f79b809e4b4ada
[09/10] io_uring: consistent naming for inline completion
        commit: f7605b87fdcf73a569c71ea74e346f239b48c7d3
[10/10] io_uring: add an warn_once for poll_find
        commit: d0093035a00357ff45bc52ed8f2c40c40e1de8c5

Best regards,
-- 
Jens Axboe


