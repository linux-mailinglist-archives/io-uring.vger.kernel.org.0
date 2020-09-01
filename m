Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B43259087
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 16:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgIAOcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgIAOVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 10:21:49 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BCCC061244
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 07:04:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so727790pgm.11
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 07:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=09MkkNOLC8M8RSdh9n8zv4do1iM4wRSRBwAgNGXkEHQ=;
        b=Y/1+XIE2nwUa41VArhTeQs8eind48pThq7+2ECu8xS0OxJoXjk+dI56puZTeiExfqr
         jWb7mgzG/427qeIwkvCGOR2a3kwfDrMC8NEDivxpJbJsq3SU80TBRKGBwuBJ9IiIRsTq
         lOqsElOCFUcDrU4HYEyIPYlr5e4Y3rtrZ4iElg8NHVgZT05bSMngG/X2Dsd5KMuD1EQB
         n2goDD3MoNRqAYOeKDi9i04PRnDXxGdw1TulMJyZtxN/ub7MyaSLsNWlsREX93C8LDtO
         Iz2FjwRZoiXsQULS7pYzrbXZOVcW0HEhWkdr8acG19n2ZdcmxgF+u15JXjacQ6dW1dL5
         zUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09MkkNOLC8M8RSdh9n8zv4do1iM4wRSRBwAgNGXkEHQ=;
        b=loqYlBnJ9W8RrCd3KvjTMxgMaclNZSVWEI7GnBYeDB9DgaRpk/LJG8NH10hBLf6Ze1
         cElqDBvi/RiZusaGkL76g7PenXChEIYFdHbVV+Q7SBt4SivEQbSubSL5W16N8KssEvOo
         kH8dVl42cYJ9NfhePyfET4wCCu0SxmJwKr53wshDaRQV7EtWd/Od13QmIMV6/sX9UotG
         mDrMpGyTTGHF8ZjH5/DlnsONKz0j1yw+qnirbKycwKGRaQ+kuScrLuO8zSq4os3cG4UW
         k/iL60fI1miW4E6XJVCISPZReYh0QJ5FwuBNyjO5tWj/mEY7EVzbclVjjMav2tbjyp1U
         wDGg==
X-Gm-Message-State: AOAM530x7of/z9CRKz2Wk5MYWUjMeMuKSLoGrc+VQ3UISWaYJg4q7Rji
        /9jWzRF95354ldHuY+tNfu1TuaRiy6cv/N5h
X-Google-Smtp-Source: ABdhPJxMFi6ehN16VPEh5OAU9g9IRQzYpSARuOhKovoOCYZGDTZLwm0g6kyK/KnGa6hl7kAXNc4wvQ==
X-Received: by 2002:a62:6104:: with SMTP id v4mr1966646pfb.207.1598969093323;
        Tue, 01 Sep 2020 07:04:53 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z186sm2045066pfb.199.2020.09.01.07.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 07:04:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix removing the wrong file in
 __io_sqe_files_update()
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1598938502-109415-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c0558dc-d04a-326b-beeb-be2b136af0c2@kernel.dk>
Date:   Tue, 1 Sep 2020 08:04:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598938502-109415-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/20 11:35 PM, Jiufei Xue wrote:
> Index here is already the position of the file in fixed_file_table, we
> should not use io_file_from_index() again to get it. Otherwise, the
> wrong file which still in use may be released unexpectedly.

Good catch! Thanks, applied.

-- 
Jens Axboe

