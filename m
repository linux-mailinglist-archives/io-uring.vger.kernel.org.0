Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6A5261E8
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358871AbiEMMbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350172AbiEMMbo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 08:31:44 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4236B6A
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:31:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d25so7554782pfo.10
        for <io-uring@vger.kernel.org>; Fri, 13 May 2022 05:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Aa/3QbaHFx0YQnOTQfRmy8tJAE8m09zC5vAzvSo0JLA=;
        b=aLSg6hRQx8n124GV9mLWGKIyF7hru/VvDBp78Udccfa/SyNivS03vyS3CLbGM6ZL2h
         awqpf55BRpQFO/KXUw3Nx5tE+RIxJKH1fb/bA/HD5FH/peSIGp6OF+WA0ioVkFVKi9J/
         MmNuvstqlmwIaCx6biaG3a68Co+PAQnd/0rgHpvCzq6nRkcGEOIDbJ0FJmojpw942ge/
         TSYtz8Q9wb4PHiptD6OYJCNs7rdPoMNHyk6MMJX5ygDl2BLzTqdT5v8GPTzm+m0ZHfk+
         iObGEXZewalNZsuNHw4Aoqw2vcCvyYJuFMoMJOrUJ2Ig9znRNU1gjlCnLpklX0VA31AR
         oE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Aa/3QbaHFx0YQnOTQfRmy8tJAE8m09zC5vAzvSo0JLA=;
        b=f50f7FgYvwnxob52N6onSZMrcH7ObR+WR3wsBSy0LO8v/8o0KDLVMoPAvnL5laBHz9
         UnhGqRDpSZ0gokkkgkda8ZUqhjU4OqLTCzdIJ5GGFQUwJGe7yHF2PImlZqZNtTmpWWiM
         oE0zS9fNZiqVi4EES2oH2/A68jlVOJimqFahryoTjskNGabepJcNtiDIUQfMhlAg5npW
         mGQbFi4ztWsurYS4zOPGwjvsMEGSAuU2Iwbzau0X/wxtankxzy8Ylkf4d21TA/i5xXIn
         ju/1usOlhHNLjgdPhcuvEW1A1bxf7+ozQFnpA8Mxf9VKEKs++s83J1A0x/++D3segPl4
         PtZA==
X-Gm-Message-State: AOAM530Fm9fX4SyqKD9niBNzeSleRdxF9uUyT56pLCEpfIKl2mT/V2ep
        moQ2r0XITrQBYRixeNloZ85hDLuVAu0R6Q==
X-Google-Smtp-Source: ABdhPJxoIJPqXi+MDfSoH0GMt0dRE6IPsJBR1yQAEBzq3BiTqF9/L8T0Y5dn1kDSpkEzEMuRWsDp2A==
X-Received: by 2002:a63:8749:0:b0:3c6:aa1d:bd3c with SMTP id i70-20020a638749000000b003c6aa1dbd3cmr3875894pge.403.1652445103008;
        Fri, 13 May 2022 05:31:43 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b0015e8d4eb20fsm1726796pln.89.2022.05.13.05.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 05:31:42 -0700 (PDT)
Message-ID: <64c7ae41-9c6c-5dc9-c58d-54bc752a2017@kernel.dk>
Date:   Fri, 13 May 2022 06:31:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/22 4:24 AM, Pavel Begunkov wrote:
> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
> might continue busily hammer the same handler over and over again, which
> is not ideal. The -EAGAIN handling in question was put there only for
> IOPOLL, so restrict it to IOPOLL mode only.

Looks good, needs:

Fixes: 90fa02883f06 ("io_uring: implement async hybrid mode for pollable requests")

unless I'm mistaken.

-- 
Jens Axboe

