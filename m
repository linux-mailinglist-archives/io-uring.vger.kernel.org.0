Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAABA4D25E2
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiCIBLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiCIBLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:11:44 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD1D1516B6
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:54:09 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id s42so905825pfg.0
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 16:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eTexQVjAfjK6nrv6aep+y0WfYjhrtLSgflU5N6SL22Y=;
        b=zzFzroMpDNgH9iZCgxfQFDrKRDW0Pv7MF/RgISYEuKAyOPdBAPydGFLNm2W2sHYA9w
         STnnuClHC0my688tanNZ+6/qpBzEDMdjoAt0UXDrAo+N7drVwicMkPt195hieYVO386e
         EXTUuZMtLrQ3e/qCTU6ubIrrMQDUePP653zSpQjo/3LC3sCQZMOTquTOKNd8DEAZpMLE
         mkdxyFGwt7EOemDgL96qKqbbfmii7w2RSee+Ebuv3Ekh4vaVHXd26IJ2EezoB8ZBVlkP
         wpIYOmHNUDlF/O4HvRnbHxE6Vt8hHfHGo6MjufNnBJS1ntNBN4nJNMEvOGZK1q2PL3tW
         W2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eTexQVjAfjK6nrv6aep+y0WfYjhrtLSgflU5N6SL22Y=;
        b=oYdjR/XsFbdm7aK1/hUrluOzcBumUURosSRsuJHKdYrWpEASojn7mgVWBwvm/SJn1r
         cDkaZVOIExfrO4vmwA0n0OHb/WyV3QSJl3nvRCvBTxL2nYpozLG4b/gMyGRZtQsL0UZr
         f4Au4T3jOPHgtT/l/I3MvU8rdPXK+jCvyJQepPQJpBQvV+2T8a9w7MPJBaKGcRoVbL7P
         aE14hJ1c7ZwQwYxHBKiJOGsD8IT55EP8xRQwEOrcFoXp5cWk2qV2V9t6u473C4cKLxBp
         RUCuPDJsIWq9tzh2nzFWNDUDzH3qjIPYlJeP0sHxrucmnJpmg1ubsJ+vGVbcsNYbAAPn
         PMMA==
X-Gm-Message-State: AOAM530+dvoPO4MUxtgG5MUfKlP/li9uurm1C2hBPRcRpq385Q6awWid
        fCcRdOz9zZvN/unik5l+8/POeQ==
X-Google-Smtp-Source: ABdhPJxEIC63yEDZtSuB5XPjosITWbZjIERDKsoZUeG8A6qa0/8d05B1qeEY0akRdZqL5tuL6zTUxw==
X-Received: by 2002:a63:e215:0:b0:373:9dd6:4b99 with SMTP id q21-20020a63e215000000b003739dd64b99mr16407630pgh.561.1646787248711;
        Tue, 08 Mar 2022 16:54:08 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q21-20020a63e215000000b00373efe2cbcbsm278651pgh.80.2022.03.08.16.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 16:54:08 -0800 (PST)
Message-ID: <7f39095c-1070-7a70-91a0-b0ccb33c368b@kernel.dk>
Date:   Tue, 8 Mar 2022 17:54:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 1/2] io_uring: minor io_cqring_wait() optimization
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646777484.git.olivier@trillion01.com>
 <84513f7cc1b1fb31d8f4cb910aee033391d036b4.1646777484.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <84513f7cc1b1fb31d8f4cb910aee033391d036b4.1646777484.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/22 3:17 PM, Olivier Langlois wrote:
> Move up the block manipulating the sig variable to execute code
> that may encounter an error and exit first before continuing
> executing the rest of the function and avoid useless computations

I don't think this is worthwhile doing. If you're hitting an error
in any of them, it's by definition not the fast path.

-- 
Jens Axboe

