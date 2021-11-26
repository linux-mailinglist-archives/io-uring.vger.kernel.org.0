Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9640245F0F8
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378139AbhKZPrs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhKZPps (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:45:48 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E7DC0613DD
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:36:56 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id x6so11748262iol.13
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=eZY3eWMCLZylZcQVRlvFldRK3qzOUbWAK155NPoSgzM=;
        b=KKbrES84+imS+tPWuHi9UGggr5ST6DQHYno3fYFwXo/Wzfv43193w6eu81hoPGdSdr
         Aun7jz/1/F8XAdfFdmViTXxPuSffdPAQuBgt81E7H9NAM6j1kejzRfUeo0AsUhImZR9G
         tT6tMKlZQx5Fme+2WLSCnqqc/jlRZbehn0yAFQ6hXKTrXL7XVvjPDX3VULD4ccsUmGJM
         9PBA3uV1IjDDvjO4GIrOeFgZ3atDL7ykTt6xSbmCzcjSj+Jvs2jfGKkUqKaWIfDF+lT7
         pUZQ5Pn4c3iVi+OTL4dkinNWJiLaitHKElD5M8n7o99TKhjRcJbV/u5/iD6U03jQpjAg
         he2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=eZY3eWMCLZylZcQVRlvFldRK3qzOUbWAK155NPoSgzM=;
        b=ThofTCzbwIISCcbY6FXydn7UPcX1DMS5lGcdIZX4YxENxI+w0Gzs4guVmuAzllkT4y
         iGtbv4JuGOkyTIzHvymlTQWpAb2stZsQlbCeqNcGf3RhSB2EjAscRq4LJgz/Zwq+BkwD
         mueu+wbJ+rEG3NgiiKxV2HEPlfcXdXG9J3pKXhOurtwF5eoBSBkZnPAi5IuIkspIOLEb
         Eei6es6am5IjSWrZZjNf45VlpQSVwyTJBIvfggWDdvakrWdoiaLQVPr22cG82lJIvhEY
         EZiiMIdbQMBxqfimZATS9RHGHp6aronWZLoqFGma5mYCRHV+8uQePLM6j+cGkB5yYQjI
         Hm3g==
X-Gm-Message-State: AOAM53321n50qJgy3C2SMwMnI4wqp8Wr/kPX5LtKyf4VOVdv8sn8cVlL
        377W2Orf1o+rUeEA5vRix6+vBC54LtXQjuma
X-Google-Smtp-Source: ABdhPJxu2eLn4YdqdpZ0+fRK4CF0oldK27oSL+TTf0eB8bc0NlC5A5Ne3RkXHY3spNKL48ZHygAFWQ==
X-Received: by 2002:a05:6638:160c:: with SMTP id x12mr40953819jas.60.1637941015294;
        Fri, 26 Nov 2021 07:36:55 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d137sm3312989iof.16.2021.11.26.07.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 07:36:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1637937097.git.asml.silence@gmail.com>
References: <cover.1637937097.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] 5.16 fixes for syz reports
Message-Id: <163794101368.606591.5665140915720222853.b4-ty@kernel.dk>
Date:   Fri, 26 Nov 2021 08:36:53 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 26 Nov 2021 14:38:13 +0000, Pavel Begunkov wrote:
> The second patch fixes the last five reports, i.e. deadlocks and
> inconsistent irq state, all of the caused by the same patch and
> are dups of each other.
> 
> 1/2 is for another report, where tw of cancellation requests don't
> handle PF_EXITING.
> 
> [...]

Applied, thanks!

[1/2] io_uring: fail cancellation for EXITING tasks
      commit: 617a89484debcd4e7999796d693cf0b77d2519de
[2/2] io_uring: fix link traversal locking
      commit: 6af3f48bf6156a7f02e91aca64e2927c4bebda03

Best regards,
-- 
Jens Axboe


