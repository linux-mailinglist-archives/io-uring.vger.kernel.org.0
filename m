Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848C163B4D9
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiK1Wep (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 17:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiK1Wec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 17:34:32 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952D2409D
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 14:34:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d6so11613815pll.7
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 14:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/GLUhPDCCf7kucWFAvMfJ/3f6dWOrGWgjwB0w2qpYvw=;
        b=6tApGSAVcZHP2My3Auyzl9gqFaw+IAUnJ0zUg3mwSnaQ/uOnyR1zq4CbZIr5ezT3XN
         PJF5GZ6UCQHAX9WLXfdyGXGk4ObswH+pQEh4N6YRRAL0ArPZUJ+lgel4MKcrBje/0h9/
         vax5QJ7LwoJY1gZ4wM0rsiYygo6u3WgtOkNS16OafijlMRRE2jVXFCv8YMU11MyCLR8l
         1PBuUTkhZN5qQq0ZAMoGUaP9aca+5L1fNdFLXmk2nJd8l29Af5x60klXRz3hGRbHrmJZ
         BG+sfcziJStm6Yy/tsinXIz70Do8vHdkpnqmyVzlV99tiwy+lsmlFOc3O7JoLtI+o9bf
         QnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GLUhPDCCf7kucWFAvMfJ/3f6dWOrGWgjwB0w2qpYvw=;
        b=2mgVaHFGGS/kh6sh2PDZct5TJH017pPg8ZrixSw+a3MNC+hiyDM0h1fxC8/DyvAlIj
         DFLJAAeqXZOLGy3utyw44awvdCIOYhKmOSWfwA1ZWEpu9aCiXEo4TASNDvBmv+cg9eRV
         YWSv2YaYJoHqqA1cedO1yLK7ZQwuiAfhnk81PbYWg9a9hR8fwa+l4jpF0kSyrz4XhqWM
         IWhyAf95ut7LBaZHbETAmfpWneQJiz+OV9AZh6e4zDNf5DrRXDy36xji0qp59d//sRN/
         xzwkZsG9HLFNn10qT4tX7ESTSZrS7MulF32rl2rG5NiON9UILiJkC5yxoy+3cmFUsjN3
         QHtw==
X-Gm-Message-State: ANoB5pnJoTLO2h6LiIEC+8lJ90CvW1Psl6ccSuaNpN6cStmXHLyOkYH9
        07y2lCaxZEsExKcpIQ2o5eAcCA==
X-Google-Smtp-Source: AA0mqf4PEb0x8rOV0Vcqv/DiNWHurjZZdbFpcK5BQMQMXDgKqdDkWgdw41uQV+2e9mVBEe/BspnpOw==
X-Received: by 2002:a17:903:2491:b0:189:854e:93a8 with SMTP id p17-20020a170903249100b00189854e93a8mr8589333plw.124.1669674869873;
        Mon, 28 Nov 2022 14:34:29 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 66-20020a621745000000b0056c2e497b02sm8833430pfx.173.2022.11.28.14.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 14:34:29 -0800 (PST)
Message-ID: <5901e89b-4ba6-2c77-892e-c43776842b5a@kernel.dk>
Date:   Mon, 28 Nov 2022 15:34:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [syzbot] WARNING in io_req_complete_failed
To:     syzbot <syzbot+bc54516b728ef2a08d76@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000052344f05ee8ea3b8@google.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000052344f05ee8ea3b8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz fix: io_uring: always lock in io_apoll_task_func

-- 
Jens Axboe


