Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07D357B20
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 06:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhDHELW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 00:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhDHELV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 00:11:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32025C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 21:11:11 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l76so451817pga.6
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 21:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4hU8WvDfhXlFeOvekHtrjuTJSIJP+3nrOpXB8VkL0Ag=;
        b=v4zy3ZLhN8E3MlPsM2Fr+WZ8xqgQvXzuBJ5knHcz+QWKIOuiGUIrQazOV47RFvCcNm
         FkbdEpJvyMm0L6GrLNWeIDMJ6f7BPLfl857d9Gras2WFvitRsGapQF7uXhGVfQ6F+kbk
         xFcwheGNsV8B+TPrcLzlU2Wa8NfTjDTvy9XI7HARMAi4P9dlquEuq3lQt87X0CIu/0YP
         NvFmj3s6xDL2PkVOM7Zb0VQcED9hkSWygl4uL6MlBik/SQ6NvBzGVgd58+Rd0Jb8E2lH
         xPCjJsNjhQ3CLxGMP6GNpiaEgISyyOGO5azgUU7uCqdM1vOnEOFa6M0a35W2684id1DV
         JNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4hU8WvDfhXlFeOvekHtrjuTJSIJP+3nrOpXB8VkL0Ag=;
        b=WP+SOfTcQBVFFneIVj6SY8qVk3Ki+AWr+X66YquX8Q3eNVIbbKOS9EEbCYHaFu5enY
         prKN4zHhouLKKXbDfM9YP6Tn6YD8PwVe/bWLu3RqRlkhdr2Xwyyty5GWkni4xLDfqxWg
         CfY6YVhfI1GMfF03mWdJNE6yFWHEqwgZckn4ttzJuERwUp/AOyldAAymJpnDX1QX9dcg
         fNb55r+dnWjngbLeXcTMgRdRU/CuOH8bR8JUdIIdWU85ZmJNnFrV/rYdW4d6b1BBFx7u
         TKdp1uOslkavnR4C1wUmJWYln4dQDmAYxiytsQY/F98IzHSYkcFA6fQ2u/zRpDKkaSU+
         y/dA==
X-Gm-Message-State: AOAM5315bF3bZ2VBa/RLgSJOd9vOt13dqd9xwTulqNnPSrRw0vtnhChS
        n/0vt0ReQoG60wCMI0PFghiN9Ka2nq0j/Q==
X-Google-Smtp-Source: ABdhPJwj3h/d0I/c0qcxrvtmB5vemcbqdfq2eK28Pduw/IADW2PCoSX+bZQQJ3nVV0AAQllDY5oabA==
X-Received: by 2002:a63:f959:: with SMTP id q25mr6541775pgk.104.1617855070477;
        Wed, 07 Apr 2021 21:11:10 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n23sm6925050pgl.49.2021.04.07.21.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 21:11:09 -0700 (PDT)
Subject: Re: [PATCH 5.12 0/4] 5.12 fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1617842918.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca61f47a-3fea-4cbd-7ba4-0a6e26a4b9b8@kernel.dk>
Date:   Wed, 7 Apr 2021 22:11:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1617842918.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/21 6:54 PM, Pavel Begunkov wrote:
> 1-2 fix REQ_F_REISSUE,
> 3/4 is one of poll fixes, more will be sent separately
> 
> Long discussed 4/4 is actually fixes something, not sure what's
> the exact reason for hangs, but maybe we'll find out later.
> Easily reproducible by while(1) ./lfs-openat; and also reported
> by Joakim Hassila.

Applied 1-2, 4/4, thanks.

-- 
Jens Axboe

