Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944FD4DBCE5
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbiCQCQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCQCQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:16:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3279A1B7AB
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:15:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so4228434pju.2
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TOPQk0EfgWNYe+AY0/mWhhD6s/eD5dl/35hcflwkvJ0=;
        b=RPTHmTvRfWpqBxjr1j/bVmwvNWsSfrIKDVynnwpXXiIz823SenB5kWiHpYE7TEoTd/
         QsqRHFBCVsgJN6AJy2AGh4hca8JY+J0lRaVMPvlCr//BDERZ2TCs4ZT8kOL/jtJPGCiI
         HfzH6TIliE5ARdCe51oHL/qA+TuYmrekmV002mcIxV5FfTkCzyVEdWGbNon3yN+1qy2i
         F8k+65SaQb1LGt6ktqvsRf1TuiBxpfHtcQxsACwwAh3qg6zkP7vcjg6lQNM9vVBGPVej
         aa42O9jvKwaKuvu9hDy/OWjP/lgUWpGZHAJ+99ZhkQ9XN4QPlHSAH+cONqjY5J8VzJQv
         GTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TOPQk0EfgWNYe+AY0/mWhhD6s/eD5dl/35hcflwkvJ0=;
        b=uqNSWuYqbLhvcBjOMv/FVn8JLq2PgKwT4mznS1LKvNZXAwjplUPd5gKqEvMpp5F6KG
         SkZAVpFs3UnB2tRgtXZZKM6C1ezFA0KGFKRXRD1WhXs40qqFvY4YzKP29LHd/OMwB+GX
         lLNARdP0eSvDC/BSt6GIc0p1ATVAjhRel3pxAGkxUTd1J6PDIIJHbAtEGeNMxfAjLxvc
         RF0hHkt7xtMBgcblE7MZX3AHwZAYwQj9B3BODTEZA7vEEjbea1pv+rZGf535xFjZt0p/
         q9vlr898Lsa/aDIYk/BJNZhfJZZ3pgvQjsHohiBUPkBkoQLoIg3QPzg/BcO9mZKFwq2b
         0bew==
X-Gm-Message-State: AOAM531EArUzb2WNYDhcl5Y7vPylbfM8gqp6Z2YhLaPWau8CbRC6ryUP
        mf4ckrqUYbidnlZMEEg/dqOmutGMi2uCiDwg
X-Google-Smtp-Source: ABdhPJw5dHERO/VoNNdQp/uL1qucWitWg3urQ6HjuKO+cKpnvcfztRu5U/QF5QnKWHJhPOGKnM5VLQ==
X-Received: by 2002:a17:90b:4d82:b0:1bf:3c6a:bd66 with SMTP id oj2-20020a17090b4d8200b001bf3c6abd66mr13271453pjb.151.1647483300610;
        Wed, 16 Mar 2022 19:15:00 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a001200b001c6320f8581sm3849674pja.31.2022.03.16.19.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 19:15:00 -0700 (PDT)
Message-ID: <7e0d6742-2614-0a7e-f0b8-56dead3ea23c@kernel.dk>
Date:   Wed, 16 Mar 2022 20:14:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 3/7] io_uring: extend provided buf return to fails
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647481208.git.asml.silence@gmail.com>
 <a4880106fcf199d5810707fe2d17126fcdf18bc4.1647481208.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a4880106fcf199d5810707fe2d17126fcdf18bc4.1647481208.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/22 8:03 PM, Pavel Begunkov wrote:
> It's never a good idea to put provided buffers without notifying the
> userspace, it'll lead to userspace leaks, so add io_put_kbuf() in
> io_req_complete_failed(). The fail helper is called by all sorts of
> requests, but it's still safe to do as io_put_kbuf() will return 0 in
> for all requests that don't support and so don't expect provided buffers.
> 
> btw, remove some code duplication from kiocb_done().

This really would be nicer as two patches...

-- 
Jens Axboe

