Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FAD5F7002
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 23:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiJFVOj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 17:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJFVOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 17:14:39 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E651165AD
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 14:14:37 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id l127so2268690iof.12
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 14:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcSlJ8adcp2XsSNdB7qHa2fR1vBH5YgDgXnFomy1BDE=;
        b=hbzECn9iygzEn71cyWufksDqQla/OA09CYeoRxNvJZKbAGSZ1ZGTWC7YPPEoQWh02l
         UshEmHMRy0DsLA90JZRF11HSyKp4h6YS6xEHeYZjnREghK/bWsofMbfS3LodrmUxxwx2
         rnzQuRUSoy+iJXAxP9mOtzENxmY6p0VdThtoKNaxShvd0wQIT96HMF5oTGQ1D+c3yRT0
         GwEJMivLvgh156HHj0BH75kap8WuGdRMty9AT7zP+AiSZAFyKwT7W+DP6d4PEUoIBn2J
         HlkODz8WI5C48XKqsaQuluax6begAMiMQHp32kpsIVEW8SUHbiS9maCxe9Mf23ndHmvy
         S+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcSlJ8adcp2XsSNdB7qHa2fR1vBH5YgDgXnFomy1BDE=;
        b=5gGQpmMnt8KCgOV+l4a4H5g+talj+uB+rf3aigV1AqE/KnLcTI5qyQqz6+zWgHjv+N
         atkioBMSzge8CplGyWei1oMhxxYW9QGBQ7OQjnX/CtKCaxT5Vagxj9nrHnNRBQaNVAoA
         uKTR06rHDjSLNvrSkKELYapjR9sjmxNyYGRmduqZ+yI+zd5XBddsgWZLxNWx6qvdt3P4
         mOstjeLCBvD6K4xooeI6SOMkKf+Y4wlsadPAMyC6Ikr83HRR1zgyUJzVUOO61ShBtUiA
         GtmKyGM1iFw6RXtUf6RfJ07b6Oc+HXxJYXSB7zHDE0a/nFZtQYurbOGDgKohwo+7GK3v
         r1Cg==
X-Gm-Message-State: ACrzQf1c1kp3Z0IiCadM/edXFQ07hmU2ctmS2YWFNbkpkxFdIfMWMnCf
        pdjbUiO2TcQQtVomqTjMRKCiYiOwhKuC8g==
X-Google-Smtp-Source: AMsMyM6hMxxMnzwA+ZxuqsZ0BKFF+xH8ZdQBnXHXZyxBN6LMtQnGAzWQDqrZwVNtlZEFMIG9muwXPA==
X-Received: by 2002:a6b:3e55:0:b0:6a0:cb10:e1f3 with SMTP id l82-20020a6b3e55000000b006a0cb10e1f3mr796394ioa.149.1665090877005;
        Thu, 06 Oct 2022 14:14:37 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i133-20020a6bb88b000000b006a0cd2ab8dfsm240998iof.8.2022.10.06.14.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 14:14:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Dylan Yudaken <dylany@fb.com>
In-Reply-To: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
References: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: optimise locking for local tw with submit_wait
Message-Id: <166509087618.78634.2540517773805800646.b4-ty@kernel.dk>
Date:   Thu, 06 Oct 2022 15:14:36 -0600
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

On Thu, 6 Oct 2022 21:42:33 +0100, Pavel Begunkov wrote:
> Running local task_work requires taking uring_lock, for submit + wait we
> can try to run them right after submit while we still hold the lock and
> save one lock/unlokc pair. The optimisation was implemented in the first
> local tw patches but got dropped for simplicity.
> 
> 

Applied, thanks!

[1/1] io_uring: optimise locking for local tw with submit_wait
      commit: a2b61c4d8fcb005007bae5b2f007d43cba89baa1

Best regards,
-- 
Jens Axboe


