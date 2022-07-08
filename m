Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA19456BED6
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiGHSMF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 14:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiGHSME (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 14:12:04 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F2773580
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 11:12:03 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id a20so8560822ilk.9
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=e/FL4eXFkwF3gw3LXCB4JMWYrLC5Fn9LK9+Ap4KI5oY=;
        b=od8QOqaFAjnFiSR9Y0ftycE429lf4LVWzaPHMoG94EfmmvJg0QBKc3MvqkDyhPVEQO
         790ZsAeywjp6qVQC59Gp/Fpel0R8wYgsdQ8LeTNFRNN1f0OuErIxv+1iGwDxrE9gdBXA
         tc/cNlbN6ExBb/1+4tgZXDHGzVXfwTty255ygM4lgYDVuvw630TPkFbqOMvdSd/DE9qB
         qw/hMZsUWM7tVBQaVmNVCv+cKBoOp2463/cw3tjI1jQDBK+GwnLByDGUUegzCQb77+1v
         xCNkSwTRrjVBGs1RrXQoimbklepq3W9skr1pigkAPmWpFa2OygpkA2Y6C9bzi9F1M/PA
         o7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/FL4eXFkwF3gw3LXCB4JMWYrLC5Fn9LK9+Ap4KI5oY=;
        b=lkY3Rvmc75nwCWdCbj+ncoEFxfXffZ6xABQ4mj+GVVpv/EL+HCxQVptIHj7CUh+FdK
         g9f6VSrpGbB3NahmV/acyD+Y3m615BHjMkedJ+BZlDk+bsCO2PywaYRO4oI6UIhTQyyH
         VYHp25VwYP4oI21RdToLLdjLD4yKqFTauPi7G3N1kK1DSA07Ggtb0v/tug3dJFMRY7pB
         FDpky48ATGqqOWnhcnkgnkjxyIzoHDjl691/K1bG+sJreX8xuE0ZnPbLaMhxW7M4yYe7
         sEI5cacg5a3vbTwRTflv8EY5+KJS7PC87uE/TIkBILrnfHuhrjUufPUyXZIplXDTu/lp
         Ssjw==
X-Gm-Message-State: AJIora8ykXTMOygxFCmFUEqezalKlcDAGtYWBw1NDuSjNAvd4NdmSv2C
        eFdTIS61YczCiCAcXiWLoutQJ0+DyO7Dqg==
X-Google-Smtp-Source: AGRyM1s3TyyEDesLCRazYVIxFZjmX7Ce8O5RnrVUGJ2/JjktfVuqH+QfGWopK1tzsRgq/BGFM6q7aA==
X-Received: by 2002:a05:6e02:1708:b0:2da:9eef:5bc8 with SMTP id u8-20020a056e02170800b002da9eef5bc8mr2922163ill.153.1657303923167;
        Fri, 08 Jul 2022 11:12:03 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a23-20020a056638059700b003320e4b5bb7sm18601627jar.57.2022.07.08.11.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 11:12:02 -0700 (PDT)
Message-ID: <3addf90e-d9f6-4771-7f10-1ad598dd735e@kernel.dk>
Date:   Fri, 8 Jul 2022 12:12:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Problematic interaction of io_uring and CIFS
Content-Language: en-US
To:     Fabian Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org,
        linux-cifs@vger.kernel.org
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
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

On 7/8/22 6:05 AM, Fabian Ebner wrote:
> Without CIFS debugging, the error messages in syslog are, for 5.18.6:
>> Jun 29 12:41:45 pve702 kernel: [  112.664911] CIFS: VFS: \\192.168.20.241 Error -512 sending data on socket to server

I think that one is most likely fine, it just tells you that (most
likely) io_uring had task_work pending and that should get processed and
then the IO retried.

-- 
Jens Axboe

