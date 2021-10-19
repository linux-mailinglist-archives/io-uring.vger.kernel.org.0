Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52137433F60
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJSTny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 15:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhJSTnx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 15:43:53 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7EEC06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:41:40 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id y17so19603974ilb.9
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 12:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TREDo8df3vkW5M6BUDEhqRGDthlFXoAWJnCyv9K+qHk=;
        b=Cpw1H3Whf7jx4mRRPqYB+7vQNKaqorppeXkZlkelKiBpFAZ5AAxqGUXy2urhJYaH6f
         Q9pjjX4USBUPnn/gH+LJSGqmvJXjKQpMmxpgfoKS8WY/LAlREZS0vqTZExl4MylPJ1HZ
         jk2SydICb8phsAndBGjnK9B8OliF4g2VfZ3PKRYVIJXz9w4k4ZotLKMHF50+U/ubZ/nf
         mnWPIMGN47upEqWBcdONXZwKGigow3qjUxCHKr50r7LY7tt26O1Nf7TrSgm7EyPHiQnR
         F7jyLoz4oo7k3a1OGWolO8cKMlnLtxKqU7hmX5qsklXaYVB/RchaI9VfjCg6H2IeSrTc
         OoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TREDo8df3vkW5M6BUDEhqRGDthlFXoAWJnCyv9K+qHk=;
        b=6doq47ocFk7ISvSNnC648S64pChtq/bVlFhL1JYZU5I9nnAahWBymEBSQrblcbO4/u
         cu/2UX3tf3fY70op+P7eUeqw8kltnoEOlSs5rTbHMG4exuclmviMbkFZgEXNYFtyMyIt
         DABYv7wtGWqftcigMmV8Ffy8ojYHAJTCiH4tMrj81SJst7p69HM86Ff5vqrwCl80rnMB
         Zh0pvkiCUxk2i0Wq1rqVTsVeF3v2rR7HlKVbuoBJfTFxiUlwM98MkSLZ2sj+hKF+JsDi
         imC5CNPDEg8KqiLNvouEN69c6p8oVJ+onJ2W9OwNCxevR4F+qvpPrQZBRR9A9VmgDDpl
         QA9Q==
X-Gm-Message-State: AOAM5332f25pP2+QHq6ixbCGu/+GAvH/mYbXiUBJDla0wUWB0oTu9L8o
        7w3cHKbgQJZ8u9T6Typ33V5E9A==
X-Google-Smtp-Source: ABdhPJzk/TtdTIKPezO/pvjIKDC+WTF/qIw4tPDYAq2LKP98mKokFu36kGezlBBac+Sah3kIhG3D2Q==
X-Received: by 2002:a92:cd89:: with SMTP id r9mr20306232ilb.261.1634672500115;
        Tue, 19 Oct 2021 12:41:40 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o10sm8692371ilc.56.2021.10.19.12.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 12:41:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.15] io-wq: max_worker fixes
Date:   Tue, 19 Oct 2021 13:41:37 -0600
Message-Id: <163467249505.692982.13541436736788529932.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
References: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 19 Oct 2021 20:31:26 +0100, Pavel Begunkov wrote:
> First, fix nr_workers checks against max_workers, with max_worker
> registration, it may pretty easily happen that nr_workers > max_workers.
> 
> Also, synchronise writing to acct->max_worker with wqe->lock. It's not
> an actual problem, but as we don't care about io_wqe_create_worker(),
> it's better than WRITE_ONCE()/READ_ONCE().
> 
> [...]

Applied, thanks!

[1/1] io-wq: max_worker fixes
      commit: 9f7f7ea493a1d5c202760cd6145d6dde744f71a2

Best regards,
-- 
Jens Axboe


