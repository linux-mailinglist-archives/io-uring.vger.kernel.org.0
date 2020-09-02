Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B2E25ACB9
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgIBOOo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 10:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgIBONt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 10:13:49 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB48AC061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 07:13:48 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so5103720iln.1
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 07:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nstCY4nIMGGeVDnHDWDgzvmoTV+BfwbaS7kuM1aizm0=;
        b=LPGSwWmgJZ3FdeZClvznODeiRKPC7C/3kuwCVtqP7ePneuiH22OrpnfMunvOzZvEM5
         9GnXvsxqKxtF0nkohr8NgjqZRy28AWhz+BNdHIOEBfa2F9VjHVMPICCRgZtQRmTALdvQ
         ZmPZyfpcj8MzF2yvMY4gadJ0kd+fDCBuE6b2Y1YjH4cmwVMksNlHWClwpT8ohh++BFy8
         2O2ZxYEVi+HTKdG+e0T+8Lveg9gkPOAzkl7JnSUjg5gHfud2+o5VGDUwcZsvELpbbrts
         uZpGrTYD+1jTLBTWOPtuRcdhp+5tq3EodO5UoUEp5eBTRQFfd0CLbs8OobGYUWBNyAIi
         QBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nstCY4nIMGGeVDnHDWDgzvmoTV+BfwbaS7kuM1aizm0=;
        b=B4C174GzJDvN1a6D2YxMu6fpQ/1+Kt7ecQP/T1VYIfI3VM8hlPsLFmhtH4S2IELeCI
         /ks1ioMgUbPzGBOqow1TzFibiJqIxFjUcqpdEFhvTH9+6CPI3aS8RfGd2+pIgTF3/Ujg
         rIwQ6sxhgqOSSMKSN1g/BoaCMVcw/rpgxvv7Es7TmzGKDfSCM9P6eFGuMC98+aSCOO5A
         9ulhPRL+y8TkKpkD3XRJ2Dp5nofFOJHNmtvaa0OvWU9n+d3E/JxWQM2S5tGQDITUHoQX
         y4KH8e4eypGjDeQCT5PAedSC7IZY1RlDYL0PC3cKtsFJWBhWxvodCnKXqJVOEAc1ZZnX
         aFHw==
X-Gm-Message-State: AOAM531dDEmgQUMLo0bwghcWbcGO81mJbIlZY/UA0nKlPrL5KglFbBOz
        BE3En/eYCaiQojET8R1Ik1Eqz9huk1W3nhlT
X-Google-Smtp-Source: ABdhPJw1OS5azBOxnbzb9W8hUefLyNrP7SkyRpuZ1ySX22X0u0NVUpeYn/jdLZILm8vWDpCOSlghkg==
X-Received: by 2002:a92:7113:: with SMTP id m19mr3851824ilc.175.1599056025493;
        Wed, 02 Sep 2020 07:13:45 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f10sm2245854ilk.11.2020.09.02.07.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 07:13:45 -0700 (PDT)
Subject: Re: [PATCH] io_uring: don't hold fixed_file_data's lock when
 registering files
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200902113256.6620-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a8417eac-3349-cc82-7f13-cb00fa34617b@kernel.dk>
Date:   Wed, 2 Sep 2020 08:13:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902113256.6620-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 5:32 AM, Xiaoguang Wang wrote:
> While registering new files by IORING_REGISTER_FILES, there're not
> valid fixed_file_ref_node at the moment, so it's unnecessary to hold
> fixed_file_data's lock when registering files.

Even if that were the case (I haven't looked too closely at it yet),
it would a) need a big comment explaining why, and b) some justification
on why this would be a change we'd want to make.

On b, are you seeing any tangible differences with this?

-- 
Jens Axboe

