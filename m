Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC800520BD9
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 05:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbiEJDUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 23:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiEJDUM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 23:20:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C5122BE5
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 20:15:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g8so13832649pfh.5
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 20:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GHgGWGcp0bG752KxR9oOaFBPd1Ft7iAj8BkDJuJjdkA=;
        b=fwrLDTY0kBNmlyVUAeej1AGRWzOgx91SPf6n2CYt4K4uRAnPmrp//I304dRiOBVsXg
         VLcDQLqt9zRWHWB2D3D+UBm2kc+dEMUAKEk34x21/M4ngbdTW4FUY2gIxtrzuoYSjrBG
         QNZ8Hod6nSCRadYkLVElMjqO1MO7zmigk0jnewaWtjntthGfsTbPRZ8rxm4r/yCehpo4
         UtZTk00tPksZQvAODddMQd14AeyezlfNSxpZvyIXk6cyb0c6y6uOBo5HUHwUV4oJJXBo
         I9bbG1Fcz0kq2PmnD/iKrFyoAb69jeQgtRXuBopjrKnQUquXgOmLpHFLAc+7gNH9Qx0h
         RmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GHgGWGcp0bG752KxR9oOaFBPd1Ft7iAj8BkDJuJjdkA=;
        b=a7MwsRFI7ZXedVmE4UIWcQaJvWmky9HHBJTd5FXcVAQiZ7I5ImkXXdEX/7aOrGD+BG
         VBWcQ3krQvCngns6Gdxv+mN6gRp3W4v3kb23ogK3E3unWIAmECZ17M0/GyfeP/Sh+Heg
         Jb0ODIc9lxDpyV2cfAOHv7eFH7rxYoIfgPCt2xm7/lMLOVfMaWgdc4HEVxpjgIoWDEz+
         jWhUTvChTC73fDSWI0024u1XeZTlJrR6lCirp4/28lERZccS4inltFs91mZ66vKDyApO
         eVLNrIAtPMSvXyLqvwUad8NI4OvtI8dl2qNWjftpY7gHoBcC12So+tRxcWmNylbp+E0C
         Jy+Q==
X-Gm-Message-State: AOAM530UzTsOwAqRuRJl3yL4zIDosBykb0KyMUKuUVJqVWLo5DTwlUXq
        Y7jAGoUNNASi+B0pjpsjrtbX+w==
X-Google-Smtp-Source: ABdhPJxJGaCwJcwjXGcNRIfJ7BJ8BV1q6mPUsAVa2a+h6GbcI/Kmy66a7oiiEeAG6I9yO4S0Y0F3mw==
X-Received: by 2002:a62:1788:0:b0:50d:dc1f:70b0 with SMTP id 130-20020a621788000000b0050ddc1f70b0mr18269664pfx.48.1652152549963;
        Mon, 09 May 2022 20:15:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020a056a0026d800b0050dc7628159sm9357565pfw.51.2022.05.09.20.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:15:49 -0700 (PDT)
Message-ID: <e43d206b-1fdf-556b-4667-c2572709c18f@kernel.dk>
Date:   Mon, 9 May 2022 21:15:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 0/4] fast poll multishot mode
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <SG2PR01MB241138EDCD004D6C19374E80FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
 <SG2PR01MB241141296FA6C3B5551EA2BBFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <SG2PR01MB241141296FA6C3B5551EA2BBFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/22 9:43 AM, Hao Xu wrote:
> Sorry for polluting the list, not sure why the cover-letter isn't
> wired with the other patches..

Yeah not sure what's going on, but at least they are making it
through... Maybe we should base this on the
for-5.19/io_uring-alloc-fixed branch? The last patch needs to be updated
for that anyway. I'd think the only sane check there now is if it's a
multishot direct accept request, then the request must also specify
IORING_FILE_INDEX_ALLOC to ensure that we allocate descriptors.


-- 
Jens Axboe

