Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7298F6EFF0A
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbjD0Bq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Apr 2023 21:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0BqZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Apr 2023 21:46:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66DA30CA
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:46:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-51f64817809so1065449a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Apr 2023 18:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682559984; x=1685151984;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0v4OeJot28bu/MHrXsD/kE63oy2vC0+DarDmhHxvj6A=;
        b=LFZnmF3kwht9f+r6DhPo09KY2HOezowVaovw/lDp5uAQim6y0D//fsqpDjAt8r+Fua
         yknVBod2dBHA7EG418Wqs9YLD0EymB/4SmqS6074Vy3FvSARR3u/pVCKYFgn4Gcsr0px
         9UWvsDNY/8xCf+imIuU/5RuIG7A+VPGghLJCwEXFOWBb7xx5A6k1f/+LhT0+yl1rCSy9
         Lc++YI4h6I013kfAXqDbMt019WIsP/ZI6q5bgEbOlc4JzsuJ1/9h9C9g8Fh73kP9NXwh
         uxWPkwioQNgnKnuJhpCO7cwEQhNLrhDdq3/MD8FnFrALMvYYoRV0QokcUkYU5m2oc3DU
         JoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682559984; x=1685151984;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v4OeJot28bu/MHrXsD/kE63oy2vC0+DarDmhHxvj6A=;
        b=Z1y8wCrcFqvjh9XAQ/ZE6N/82n27UqxI18RqSiqt7xy9Ui2x9Bj8e5tCdauKaMs27Q
         LwnUDFD8Awu01Rydn9DoamgK6sSqZcmv8Je1tacs+sz9Rle0H9U3dDfowy+zyRJVEsvW
         rQB77fN81PkdkJ5yVaE5BkMZqZK8GeKDZDi8bENRqyD4RSm+RD/psmZyo1s5Ah06RIop
         xxydAONt+6EcYtCSWPQD1EcGHAymK1b6qzIEgCNwanQ9HTg7qA91aDn4cW84t4sPmEQ9
         Ij4B/fqAUtfSIKk5XObnb5eE6SuHNmdczJNb16PjS/DdYF+OvevpA5lLkm7KRZwiU8Pw
         LcYg==
X-Gm-Message-State: AC+VfDz0k0J36UCttObY526BautCGHOe2eO04r517Pck5g4lP/X3IUgp
        JrV0h26SwzgtCi16XIZgHUoptQ==
X-Google-Smtp-Source: ACHHUZ6fK+yLTQr6EPP24p6bCM1Mtw7gmyvwN6OAgSVvTPOh11zVumK5VUhFDp7l1slUBpXtCpCMFQ==
X-Received: by 2002:a17:902:ea0a:b0:1a9:83c8:f7f2 with SMTP id s10-20020a170902ea0a00b001a983c8f7f2mr955011plg.2.1682559984222;
        Wed, 26 Apr 2023 18:46:24 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jj2-20020a170903048200b001a6d08dc847sm10484202plb.173.2023.04.26.18.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 18:46:23 -0700 (PDT)
Message-ID: <64a48f3b-b231-7b9e-441b-6022693377f3@kernel.dk>
Date:   Wed, 26 Apr 2023 19:46:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
In-Reply-To: <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/23 7:41?PM, Jens Axboe wrote:

I'd probably also do this:


diff --git a/io_uring/napi.c b/io_uring/napi.c
index ca12ff5f5611..35a29fd9afbc 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -95,12 +95,17 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
 {
 	struct io_wait_queue *iowq = p;
 
-	return signal_pending(current) ||
-	       io_should_wake(iowq) ||
-	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
+	if (signal_pending(current))
+		return true;
+	if (io_should_wake(iowq))
+		return true;
+	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
+		return true;
+	return false;
 }
 
as that is easier to read.


-- 
Jens Axboe

