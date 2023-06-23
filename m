Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E0873BA1D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 16:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjFWO1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjFWO1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 10:27:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F020C1706
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 07:27:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b3ecb17721so947025ad.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 07:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687530454; x=1690122454;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfJHTp98/oOw5l4nHZf6YnaFhyIgHrn/Fi3dEbYXx+A=;
        b=gOAEwQJHBPAeoTlRmWyNosQu79tm2u1NfMwGME0K3deAUMExw1FVsjgdPGt0S5G/B/
         sWt4mB8ZZYRAs/eu0Od1fAvS3AYkXeNf/rIYCd6445xQgnAmh+lFKjbvyHwYDWomyweF
         bkdnnYnZtN0NqnuZ/OpDmjzOqMq46dEOM9ZjsnXCp8LhlMV1vAp2nnCr0lvHUo6bcZSZ
         0meU/IoopHUcXcJszZ1haulU9BYNcWhWu+NKbCxCAZ5F0OrGONGB/lxg+B6rO25lLigO
         HBU7X1cafmwuXsglPv0xCH4UCZ1as4VicXhlxS9SMnqvNi1JTPpp2HytNRPMf2eMdyJy
         lfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687530454; x=1690122454;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfJHTp98/oOw5l4nHZf6YnaFhyIgHrn/Fi3dEbYXx+A=;
        b=TJ7BGWRshJA2xRWazHsbWAnEhRFt+l/cR0RMu+g19LhPmcZdpZ0xW2NGA6b1qmFMdR
         VdqZ9iBPPrS3SDtyevoKT+RA2C1E55q3bHgR96tcMh7USNhh6E8zaSOeP4KQBu2sMt+V
         dbBw37V88HCYivvjWPjcUzhjuHWV/3iZJJyQFbMYlPgb9q+TzwW0iXlCB9BdgR6RQfWp
         tkpVhT8kcMnGHmBEKv4RlOVBbRA/407p+zdNGxjI2wbIuDfg/6/MBmilcM3Z3k20RtX7
         7EEKkLIOKRl+JrvwwiBGN+mQKvHrWg+sL2gK9ujABjfDoQc5AMhilAVbXiT4PPq2TidI
         NEwg==
X-Gm-Message-State: AC+VfDzwEczjg4LEuP6bhg6JW8g5Za58YlrFTj6X5dWCm0OuCjg/bGIk
        YIMJC2S6jKHIp4rawYbC6KmbhAlp9X0oRLy3CAo=
X-Google-Smtp-Source: ACHHUZ4vnwons1w0D97luxGvNZaZhgOV1D1uwsaIAcmDM5JwqqsMuZCb09XNjVW3Xh4W+y0tKmfqLg==
X-Received: by 2002:a17:902:f688:b0:1ad:e3a8:3c4 with SMTP id l8-20020a170902f68800b001ade3a803c4mr24857091plg.4.1687530454060;
        Fri, 23 Jun 2023 07:27:34 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id lg13-20020a170902fb8d00b001b3ce619e2esm7291108plb.179.2023.06.23.07.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 07:27:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
Subject: Re: [PATCH 00/11] clean up req free and CQ locking
Message-Id: <168753045284.468611.12859368455659179975.b4-ty@kernel.dk>
Date:   Fri, 23 Jun 2023 08:27:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-d8b83
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 23 Jun 2023 12:23:20 +0100, Pavel Begunkov wrote:
> Patches 1-5 are cleaning how we free requests.
> Patches 7-11 brush CQ / ->completion_lock locking
> 
> Pavel Begunkov (11):
>   io_uring: open code io_put_req_find_next
>   io_uring: remove io_free_req_tw
>   io_uring: inline io_dismantle_req()
>   io_uring: move io_clean_op()
>   io_uring: don't batch task put on reqs free
>   io_uring: remove IOU_F_TWQ_FORCE_NORMAL
>   io_uring: kill io_cq_unlock()
>   io_uring: fix acquire/release annotations
>   io_uring: inline __io_cq_unlock
>   io_uring: make io_cq_unlock_post static
>   io_uring: merge conditional unlock flush helpers
> 
> [...]

Applied, thanks!

[01/11] io_uring: open code io_put_req_find_next
        commit: 247f97a5f19b642eba5f5c1cf95fc3169326b3fb
[02/11] io_uring: remove io_free_req_tw
        commit: 6ec9afc7f4cba58ab740c59d4c964d9422e2ea82
[03/11] io_uring: inline io_dismantle_req()
        commit: 3b7a612fd0dbd321e15a308b8ac1f8bbf81432bd
[04/11] io_uring: move io_clean_op()
        commit: 5a754dea27fb91a418f7429e24479e4184dee2e3
[05/11] io_uring: don't batch task put on reqs free
        commit: 2fdd6fb5ff958a0f6b403e3f3ffd645b60b2a2b2
[06/11] io_uring: remove IOU_F_TWQ_FORCE_NORMAL
        commit: 91c7884ac9a92ffbf78af7fc89603daf24f448a9
[07/11] io_uring: kill io_cq_unlock()
        commit: f432b76bcc93f36edb3d371f7b8d7881261dd6e7
[08/11] io_uring: fix acquire/release annotations
        commit: 55b6a69fed5df6f88ef0b2ace562b422162beb61
[09/11] io_uring: inline __io_cq_unlock
        commit: ff12617728fa5c7fb5325e164503ca4e936b80bd
[10/11] io_uring: make io_cq_unlock_post static
        commit: 0fdb9a196c6728b51e0e7a4f6fa292d9fd5793de
[11/11] io_uring: merge conditional unlock flush helpers
        commit: c98c81a4ac37b651be7eb9d16f562fc4acc5f867

Best regards,
-- 
Jens Axboe



