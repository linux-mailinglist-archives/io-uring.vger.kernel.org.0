Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9136D34B278
	for <lists+io-uring@lfdr.de>; Sat, 27 Mar 2021 00:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCZXIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZXHt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 19:07:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E625EC0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 16:07:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m7so5584608pgj.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 16:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8dMGW3NNPH6KeBSqsN/4K5vPXVK2n7GhMJaRLYoxTdI=;
        b=pwgm2iRdYyFSmvOtjVPPj2gT1kT1WR47rTSofebDXFr2+VpIUhAOxMDECLSjAzKOe/
         M/3nVSt2OO+hH6LASlmFnX5p2KsZqEfL7im3rcaVapF3jftZF9VWQolqah+7O1xPwr6N
         MwxXK+ER5jHsmNLBOydf5wBmWEPleJk9bMyW6LBGrpZuYSqjz+z7LFpKDDtAzLgPGbpq
         YsxpJtKiF06Mbsu80XIMhCFjs5V6cvdtUQX4tn7TWgdWRe9FVFpAfWiLvSWBzORjqpv6
         m4uf/UAPZ6Z8N8rf85/eCb/80cb8hK2WzQdL3DFLEeNbq29hV88siFplUORQEF1c09XB
         t/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8dMGW3NNPH6KeBSqsN/4K5vPXVK2n7GhMJaRLYoxTdI=;
        b=KdsDqb0sd7iyq5zT26wiLpP8P4gnwSCmSAZHga+JhZ/yZqgJ5+syr3SYwkVrAYWUMH
         WvLtO6W5OV/xNM+pnQ3k+DRdY8/uvl1vCdPvZcLA6fPPyT2+tvuoYrbE/CwwFixEzycd
         GqQzOebTCZkXnoLHDeTw+WZBELa6rzR1WUQjISA7CvKWuf6Ri/EdXcdJOWSO35Uj/fsR
         Qujm7YgucEQnmixgD6B/CFE2XdukMpjkkI3+MZWAp7vpMDkluvnhiZgeHscqW9GL3x6y
         +KVFnkHUbvcImxBBpDVYEMGlEEN1buVphtgo9wfELQ3y0eYplMebinx34XSZA3CIJGjP
         wBtA==
X-Gm-Message-State: AOAM533bR4r/+pNNBSNiOH4DWSbPVBTOwdtcIluyAcCE3w4RH1icv659
        FxiOf4myJvBhCpG5th+VJ5G66Q==
X-Google-Smtp-Source: ABdhPJyMs1TfN0Oz89SmCYz4go0u4i6QTlAdW5Mak2N/gkuqkWc0/joe8Ju/qqG4/my5p7XWfht/aA==
X-Received: by 2002:a63:485b:: with SMTP id x27mr8478635pgk.0.1616800051305;
        Fri, 26 Mar 2021 16:07:31 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::141d? ([2620:10d:c090:400::5:4d27])
        by smtp.gmail.com with ESMTPSA id l25sm10410526pgu.72.2021.03.26.16.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 16:07:30 -0700 (PDT)
Subject: Re: [PATCH] io_uring: remove unsued assignment to pointer io
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210326195251.624139-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <88e590c4-8174-73fe-ebca-de879b21b317@kernel.dk>
Date:   Fri, 26 Mar 2021 17:07:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326195251.624139-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 1:52 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is an assignment to io that is never read after the assignment,
> the assignment is redundant and can be removed.

Thanks, applied.

-- 
Jens Axboe

