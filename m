Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3857545B
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 20:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiGNSC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 14:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiGNSC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 14:02:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A84567CA4
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 11:02:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q5so1104108plr.11
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 11:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=clsXuICCJHV0kjpTpRG28NCC9w8SjNCwVC9/gJ/mbrM=;
        b=zfsZu09bF/Og1VJfcJBqy++A10ahIrBGhxa52H1FIP44+4x5UZL3tWnfHgSJaOxiUK
         Az0QFPXkNSbyfd14z80w1JYpwsUrI9E4hiIbBFQ5ug/VeF6xj1sFijFG7NiAXdOcwB2+
         exENMcVX1vYIlNnrD0QuvoPCQ9A7zNrptFBJPla2zszKzMDSO8qFA9WyiVglFmCt8QpF
         6G3EgASmsS+UpovgfvKxmHgsu9/JSXmMXCi9xLDNL77pmOgELoe6RtmrlH0090O8BCJF
         ytgjtNNUA/xZmeatoLd4lwqr54fX0u/iLeKmbymftCfh6L7HSM6RW71R2nW+L8njvbq6
         4C8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=clsXuICCJHV0kjpTpRG28NCC9w8SjNCwVC9/gJ/mbrM=;
        b=OlVf7rF+fb+1YxUtzdeTBBxBCpP9A9y1o60BB3+HPzy6HyHnu1ElYuUasAvi4PSxV4
         3A56zR9DxGI+f6Hozi+qXRMVrPPd4mbZVfJ2jORL6xz0RmNTnuiILkvT2HBS4R2bdjj/
         6xrWPiWMvplWCpf2v/FvlzloWLZ0DfvfUTHx9tYLdQNg8kwUYaqnL4xp9Rp3rxX+e884
         IGizBJ0zndEo+cX4/MP+YDDPjMiEWFkE1DE6TkPjgWjwT2o86b2NRn6+EZrFaBhvXTIZ
         WClovVCqBmETI23sffpeK2uSQCWkCrMNBzXfHvyxcKRfpGUrroVSOnpInczRVeFa0u5F
         LYjw==
X-Gm-Message-State: AJIora9JJR+eK7scU7w1P3w2Ll2tgU7QUlqUdYL+updB1Qn1dQ4krFnc
        VqoaCqXwef8e7EHSWaEv/6iFUcW3B6knkg==
X-Google-Smtp-Source: AGRyM1u9LEoOUeOMeBFosx3DVvdkTb/ckV9JXF0/pxtqKfpcveBt7JiVartEjG40R7XdXMbkfievew==
X-Received: by 2002:a17:903:1053:b0:16c:38da:97ac with SMTP id f19-20020a170903105300b0016c38da97acmr9347803plc.153.1657821745100;
        Thu, 14 Jul 2022 11:02:25 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090a68cf00b001f021cdd73dsm4033488pjj.10.2022.07.14.11.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:02:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220714115428.1569612-1-dylany@fb.com>
References: <20220714115428.1569612-1-dylany@fb.com>
Subject: Re: [PATCH RFC v2 liburing 0/2] multishot recvmsg
Message-Id: <165782174440.655281.13564803769569351247.b4-ty@kernel.dk>
Date:   Thu, 14 Jul 2022 12:02:24 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 14 Jul 2022 04:54:26 -0700, Dylan Yudaken wrote:
> This series adds an API (patch 1) and a test (#2) for multishot recvmsg.
> 
> I have not included docs yet, but I want to get feedback on the API for handling
> the result (if there is any).
> 
> There was no feedback on v1, but in v2 I added more API to make it easier to deal
> with truncated payloads. Additionally there is extra testing for this.
> 
> [...]

Applied, thanks!

[1/2] add multishot recvmsg API
      commit: 874406f7fb0942238a77041d84f07a480400ed81
[2/2] add tests for multishot recvmsg
      commit: 95dc4789e9dbacb7b3913b1a6e0dfef80fabb74d

Best regards,
-- 
Jens Axboe


