Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409BF750E44
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjGLQVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjGLQVe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:34 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538A02D55
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:33 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so75515339f.1
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178830; x=1689783630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sL82P1YWV6CNzA2zoNEPgshuUoBH9EZ0VM0eDlHLSu8=;
        b=TYbegiOdzW1d9O48+xxdFP3ms8pme++YAtFLvZR+X7DWeoyHJKnsIbaM9xDdGjQQ8p
         LdundonWsis1NxNbc1IALMOXU8edqTUcNuNbCFOS/29ZXINJnwR1bwovkzwR/Cp30HiI
         mB0U5FGHcoS6JfzCbiXpTQsqYfC8z18GvpsUWGJIbCz8hr7Kuy4XixgQv1QonQeOnwS7
         ZQJQAKTaycRoGp4akHY8g7C+NHoLLtyThJszPZfgA6iUkGc6cq3F3SCSvezv8uSokW4o
         Uy8tdpVa5UgIqHNThIpPY2oiXAiG8I6FtWJRJ/rYBi7ri/HdpkGys3aSUb4Qjd5wdNBI
         Kjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178830; x=1689783630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sL82P1YWV6CNzA2zoNEPgshuUoBH9EZ0VM0eDlHLSu8=;
        b=IaFPqtrtphYXGY4eCIQp0ijIFjIfpwl5xDgs9ZB+1J+j9CfMXtxCZMZpQUzgcUoDLy
         Ybq6UxzBNd8XdWtKJa5cKV4jew7DWLyM0qNTU7yaEd1Shz44HjeeXoqLNNAPUyIpeWkj
         NZQIqT78+iI/QRI+jY80oIYyO1jL2GEaHKnSd4EVeTtEXKzlKYiERi+nXj+CUu88FSP9
         hqc0XavBjw4TmNwzJWPC1PYWjxwB6pkPYX5Xa33wEffdGNShsxe31fgYKiLXyRExPl6f
         2qxzkOtI+8W11uK8RR8PBZp/MZECPYzNQIQjk0nIlqKnL3oQlddxQD6wgEFb/Gc8xnUZ
         sgjQ==
X-Gm-Message-State: ABy/qLagmosAmASzjrXqorTbJvju+mUd6FyFwfkENHYjecv66LTC64h/
        8gkAQ/JtAobv+du/PaiOO04D4mVuPbRd0n5+nT8=
X-Google-Smtp-Source: APBJJlGFGI/ygJ2orBnEl8g5Shwi3/dBVcXTZSwtwKg5hAJTd0GoFVTSESNxXi5QZZhXvnIomP+8Hg==
X-Received: by 2002:a05:6602:2f14:b0:783:6ec1:65f6 with SMTP id q20-20020a0566022f1400b007836ec165f6mr24773948iow.1.1689178830699;
        Wed, 12 Jul 2023 09:20:30 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] futex: add wake_data to struct futex_q
Date:   Wed, 12 Jul 2023 10:20:14 -0600
Message-Id: <20230712162017.391843-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
References: <20230712162017.391843-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With handling multiple futex_q for waitv, we cannot easily go from the
futex_q to data related to that request or queue. Add a wake_data
argument that belongs to the wake handler assigned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 1d531244fb71..24180a95bdc8 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -102,6 +102,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

