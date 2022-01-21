Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F68496654
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 21:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiAUUX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 15:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiAUUXX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jan 2022 15:23:23 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9BAC06173D
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 12:23:23 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 128so9841270pfe.12
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 12:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5extsHPJIpl+33f31/X5C2nbiFKq7TlzQztX8Xra8yI=;
        b=5JCrCE2yKw/IebyzVQfAC5R/IhbSfRieuihsbkzRvVXyANMGvIsFdpGDQ0n3J6JvUr
         KQxoFnYOkolIbEQCFCRjW9Fkqtp8r3/30H5a6PrngvusOT/Ige/ynzRTqP6EjCHl1w1V
         bDeX4Ng+nlzfKctcicp4lUc3jfhBI5Q7QjvVNYqPIwIUgrwABaTPjBMIvmxTz6fQ6iCY
         v5c2YYCIin0q5fSgbEZE+6VG+dDpJ2djVdnRGbMYdfVhny0OQQbA/tS84hroqvZxvlaQ
         hMWu8kRY7li4Q4c6to5DWmlj4cw3QxR65aVs+RRwZ7XyG4r2pEhhsq+3Vg6j9uwLBRMy
         zsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5extsHPJIpl+33f31/X5C2nbiFKq7TlzQztX8Xra8yI=;
        b=IhbdVfj0ganoUHYX5Ly6Sn7hb+t5sJLt5FIKKsC2v01AoKS5LXch5e5SMoeY9ywe8s
         /ykSamJkjvXKF6k3nzqFKydyJ4p5ZxLSsRRDPg8/eEfOEof84gtkAzkqXNCfGi4oR3ZJ
         Tm/0+62fOT3Gj89EU1MIGJZw8qZHkyH4ywN1VgFsiW+3P4pFFJcgmliW0PhBBBQwTChl
         /F2hAk7LzrVsVrQbov5iV0iJYlkhQD7WxJUCFbLTFYLDgmppsGhDF2YNDDsGEpdngsZC
         ZFNrXZR6hB5oIzm85Ngnsj/Ie55BJUIaDHsBza8EqIMgCe1I6guxpewQ965BI1dUOUxo
         5g/Q==
X-Gm-Message-State: AOAM530uUJ3yYhlZIgSMtpe2jy/57ez9ZkMY2ocHA4D5m3qCef0ogqmy
        AkCt7AZ2+k8LBUJOGoiyZzqkgQ==
X-Google-Smtp-Source: ABdhPJxaToLDKT4OmyIhuC1xQEo94A2Im5GR+8TzLbDRLuSrqLnnc0pk835tfMms0oa/Al6zRKzneA==
X-Received: by 2002:a63:40c5:: with SMTP id n188mr4100541pga.118.1642796603001;
        Fri, 21 Jan 2022 12:23:23 -0800 (PST)
Received: from ?IPv6:2600:380:b460:6171:7e3a:1652:bbc1:abee? ([2600:380:b460:6171:7e3a:1652:bbc1:abee])
        by smtp.gmail.com with ESMTPSA id s13sm7766092pfu.0.2022.01.21.12.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 12:23:22 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix bug in slow unregistering of nodes
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220121123856.3557884-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <628fcdf3-f03d-fdef-7bb9-9b033fc1234a@kernel.dk>
Date:   Fri, 21 Jan 2022 13:23:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220121123856.3557884-1-dylany@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/22 5:38 AM, Dylan Yudaken wrote:
> In some cases io_rsrc_ref_quiesce will call io_rsrc_node_switch_start,
> and then immediately flush the delayed work queue &ctx->rsrc_put_work.
> 
> However the percpu_ref_put does not immediately destroy the node, it
> will be called asynchronously via RCU. That ends up with
> io_rsrc_node_ref_zero only being called after rsrc_put_work has been
> flushed, and so the process ends up sleeping for 1 second unnecessarily.
> 
> This patch executes the put code immediately if we are busy
> quiescing.

Looks good to me, and as far as I can tell, this bug was introduced by:

commit 4a38aed2a0a729ccecd84dca5b76d827b9e1294d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu May 14 17:21:15 2020 -0600

    io_uring: batch reap of dead file registrations

so I'll add a fixes line to that effect to the commit. Thanks!

-- 
Jens Axboe

