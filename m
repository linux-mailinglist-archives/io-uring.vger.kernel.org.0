Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598E7656BEC
	for <lists+io-uring@lfdr.de>; Tue, 27 Dec 2022 15:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiL0Odv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Dec 2022 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiL0OdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Dec 2022 09:33:18 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB79B1D0
        for <io-uring@vger.kernel.org>; Tue, 27 Dec 2022 06:33:11 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w26so8964008pfj.6
        for <io-uring@vger.kernel.org>; Tue, 27 Dec 2022 06:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grrvRaR++ux1N4YDTd5/ntN/HSg+L23TD6UQMjE11tI=;
        b=MqiZIN2Y6DAumu6+rZMN+Mr12AT4tXV9Oh5rX/c7wPLrg5hufWjmDm6j8DRRH2nUKs
         Pd+4/3au3Wy5pRR85A1yHRLgMzD2UofHBJltPjDPBS3JpmGS3KmuHxwJAGfnGXCNTIhg
         rV0m9uC8riAHn4ZnBOtR6Zg8iWMXps09iD9otdTdOwBfUmdnTUcOtjE7HjGuVI+MbdEK
         4Ze9X6M+q0sRwuphXKbf8OXUyHCJvk9+IZGXYJLG4wgOn/+TnodMK6ErhCThBdAsuUj7
         16p3MWTDYirBhH0IoD0WN9TGAciZq4OvgLxNGY6gtI9GJ15TNVV9ih2gjM/YVafo526i
         xNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grrvRaR++ux1N4YDTd5/ntN/HSg+L23TD6UQMjE11tI=;
        b=KJmQ19DzBdybBD9wipYTjTgcO20L50sO4YNRaeu0TmTXyzdRkb1M4Qvx/+OD4av4Nq
         h10V+jcyGdao8AAJ8zcD2tuhRFMOyvmzsMuW6pj59Lj5o82RpAtKNY043ji6i6bFmNz1
         btHiwW65YbCfkT6e6HjtFTYx5r9N0t8lMjakxfSfYVLV3HlBdM1bqu46WwhXu7Si5vDt
         t0I+IhRM5uQWXLNht4O83RUnPTN9hdIuejI/W9+U0Rztw5EzXTnWe3PDgZI8HQys2HPg
         z/oEVUrusyUwHYw9T6axWVVdKi+ttjyoKSXDTSvHNgxXJJS3n0zRrujevvTyS157njwu
         bbsQ==
X-Gm-Message-State: AFqh2ko38TKcjpSetPPp9bHkecN3Q2cznzNEZn8SVku5zTPXXlXeH/Sa
        ZpVKrVam3a+TMpYpavNi203kqo2IoZZTgbX1
X-Google-Smtp-Source: AMrXdXt+RNCxytsfloBfSZxurt4CfYLeQfOMZV80oSP7gaDOTnmw4jRoEb8qIR9fCHKHE5QLCiQJLg==
X-Received: by 2002:aa7:9e11:0:b0:57f:ef24:2237 with SMTP id y17-20020aa79e11000000b0057fef242237mr5403071pfq.1.1672151590528;
        Tue, 27 Dec 2022 06:33:10 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d68-20020a621d47000000b005813f365afcsm2998636pfd.189.2022.12.27.06.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 06:33:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
References: <cover.1668630247.git.metze@samba.org>
 <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
Subject: Re: [PATCH v2 1/1] uapi:io_uring.h: allow linux/time_types.h to be skipped
Message-Id: <167215158915.44294.15174860895720844240.b4-ty@kernel.dk>
Date:   Tue, 27 Dec 2022 07:33:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-7ab1d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 16 Nov 2022 21:25:24 +0100, Stefan Metzmacher wrote:
> include/uapi/linux/io_uring.h is synced 1:1 into
> liburing:src/include/liburing/io_uring.h.
> 
> liburing has a configure check to detect the need for
> linux/time_types.h. It can opt-out by defining
> UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
> 
> [...]

Applied, thanks!

[1/1] uapi:io_uring.h: allow linux/time_types.h to be skipped
      commit: 9eb803402a2a83400c6c6afd900e3b7c87c06816

Best regards,
-- 
Jens Axboe


