Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA94D661796
	for <lists+io-uring@lfdr.de>; Sun,  8 Jan 2023 18:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjAHRlx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Jan 2023 12:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAHRlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Jan 2023 12:41:51 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E70DF31
        for <io-uring@vger.kernel.org>; Sun,  8 Jan 2023 09:41:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id jl4so7057061plb.8
        for <io-uring@vger.kernel.org>; Sun, 08 Jan 2023 09:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GutKW8U2GM5XZih+XF7hrer9blrDoFElwh/AVJL3Kiw=;
        b=bz1YBn0J1v2FzSyZ/9+9yoBi/gRTJ8so+KoKcgMhp4pKQOGvgVF2oZP0PXbeY/DIrS
         8Tn6I7aPJAEE/mD96vNVltwvIa3AoravwhMIV/A0urYUKFUTVwOInbcYUtHWvmcLCkMj
         GacZJW3vRXV/4TzBE3m+C2kkU1eMGnXD+TiGrhhCIgZsKqjKUhL58wMvF0SSflSmPfxY
         c4zcMhu/fCb8mNwjOKfgy5EZYzNXgoMRwEgN2PBAc+miuVF35+hNZlxVzVzdSfjQSPu2
         vWyaXssx2w5KqrXEp+FWYLUz8vc0EHSI4CPnHEaLtGtuYa7zM/gUnTJNhRxsi4nd2PAD
         lk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GutKW8U2GM5XZih+XF7hrer9blrDoFElwh/AVJL3Kiw=;
        b=g/OsITrN8GiS4/6/AsEW7ZpNYkkwT8Q4f3XAPzHcfFsd24WBv+9+jkD1oOjEKYxQxw
         fHzZaYdXyoHS0L2EpmLmGuqzpfSZu65VIxcc3HKaPBIxYHbKI3rjPxzggbs0qAL6NYT+
         cLslLuToPp2kVbe6XQ5xL3Hxmaf2IljFuYbcFHm2QkYwtxFpoTuM9qaeY4FjMHnMZuNU
         yb4i0yVPT3YCe5h2qEXrKqolRu0iu0v2vZBLtwPD0ZaQWYF39hPVpHY+oW5SX14J9eJK
         +2qpCF5l5EDZDV7iHaPBoyrZjGEkJ7No1lnzPe14brspvTNadpn14EQQK8QgGnpL050O
         eTuQ==
X-Gm-Message-State: AFqh2kpW/S7+7YfrAxHiFf321DwO6AI8ASaqp2bPpu7cBmP6uSBPPcJ0
        2FQWuVPQcEO3iM7Pf/vNBg8zlQ==
X-Google-Smtp-Source: AMrXdXvq7u07iI37P8FUF14nYn9//pJL1lqSu7CaGUhQPyGUEcvHkFEpSU2KKsdmRNl6OBR/Rz2PaA==
X-Received: by 2002:a05:6a20:a6a7:b0:b5:c751:78ac with SMTP id ba39-20020a056a20a6a700b000b5c75178acmr454349pzb.2.1673199708933;
        Sun, 08 Jan 2023 09:41:48 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902eec600b001811a197797sm3253734plb.194.2023.01.08.09.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 09:41:48 -0800 (PST)
Message-ID: <4be0a7d0-a1ac-1cd4-ccba-77653342efdc@kernel.dk>
Date:   Sun, 8 Jan 2023 10:41:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] KASAN: wild-memory-access Read in io_wq_worker_running
Content-Language: en-US
To:     syzbot <syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000019558e05f1a86b19@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000019558e05f1a86b19@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux.git io_uring-6.2

-- 
Jens Axboe


