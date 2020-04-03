Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA5F19DFE4
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgDCU5I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 16:57:08 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51937 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgDCU5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 16:57:08 -0400
Received: by mail-pj1-f68.google.com with SMTP id w9so3565926pjh.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 13:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YHVG9CM6BzrhECJE1SXvMiP4MCxCHfdUunR2fKLkSsM=;
        b=I1dgGA1AaQPMmwg6RNDayjsIPXeGGTPWEpgboewoQtPPb3c6euekjcgAaELwso2l+P
         5Udpi30kj8oj6KlXhfzJ5Ez1hkagI30wND/ZAAEOMlfQxW0B10Yp7fsRkEvGrOBMixUJ
         uGdA7ZBljBTxVGGCtBJ8k8Pw6CyRM3GUyaWU19gVyCe7MS8PioBnFgocfsSkDa1oie5W
         68lTA90nM73BXEe13Ge4lkSBXqgCep79kmlwkaQwC1bi8iomkGUzRoa85kKjYIx+nxSF
         3vWvGOgthv6TuzlOfaMEChDa8CIdxcbfJEUE2Uy1auVA4+16r7fFY9ULRJG07LUYZqR9
         kbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YHVG9CM6BzrhECJE1SXvMiP4MCxCHfdUunR2fKLkSsM=;
        b=EZGcmOn7zeSN2maLq+Rw8c4erw0wD4f2zCMhEr/wkTnn4uIbfvDrETisaOuH+Ai420
         7aIabSafRTUKmqYtMYfplv7TvczyRpF1sC4aIq9zBCqEp9RkRLWszNFGho9jnRphMcIq
         i1unklxvBlIIP8qk7aqkEFhex1LYZNdFd9dGkNQ2izZvg9Eaxg7dLZkmZj/U6czGEgRS
         eH6RoRz1B/zU0nuKUETKJxx/OoMikWQmzyz56TS6+rfXdH0e2/W9k9jfsMHtH1OWaF1S
         jvuyj8hcqlop95XK1DSOWBDMO1TB+Gts4+n2z5Pq5VsP+cHIUV2/0pjyWj2mZklX61EZ
         z8Hg==
X-Gm-Message-State: AGi0PuY4Lw3bYoOgrA+H9lA+PISBycnGn4WfV3vetVh2b13CH5BK6AMC
        XKUS/NjIDxr+/KOepqCr0hI5jP/8ke1CIQ==
X-Google-Smtp-Source: APiQypKl9E1BGTD1dkpiXMTRuQCgXzk10z/HVC6mvk6UG9AWk7cOL/u2e8yppsSIDIujJn4cdu573A==
X-Received: by 2002:a17:902:6544:: with SMTP id d4mr9832835pln.310.1585947424976;
        Fri, 03 Apr 2020 13:57:04 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::15af? ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id p4sm6325083pfg.163.2020.04.03.13.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 13:57:04 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: process requests completed with -EAGAIN on
 poll list
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1585947093-41691-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1585947093-41691-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9957b9a-00bf-8cff-b2dd-385476a158e9@kernel.dk>
Date:   Fri, 3 Apr 2020 14:57:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1585947093-41691-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/20 2:51 PM, Bijan Mottahedeh wrote:
> A request that completes with an -EAGAIN result after it has been added
> to the poll list, will not be removed from that list in io_do_iopoll()
> because the f_op->iopoll() will not succeed for that request.
> 
> Maintain a retryable local list similar to the done list, and explicity
> reissue requests with an -EAGAIN result.

Applied, thanks.

-- 
Jens Axboe

