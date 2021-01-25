Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157D0302121
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 05:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbhAYEeQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 23:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbhAYEeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 23:34:06 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15438C061573
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:33:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id t29so7667476pfg.11
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OaXwiorPjTpLFTdpmKT1HPGDgk/XOWSbm8f+u9PPuog=;
        b=GiUufzAE7zScSEKM/w7dQy7yuaUA6XI1UgXN3/+I/Cgh59UeGUtFg76k0AMDdcgcya
         k6XNKaCxDy163xMeO4tIy86vGoMEkODslbhZoN7VzulqDh3fag5bgUUXAlDPhCBIB9Ri
         5hB5iJ7tSexuOGEKF/qJ7dXLhD22Vq9xhvJUIZp033C574sphiPP6AdwdbsIJ/ALEAFK
         zopaX3ob44dDFHaB5+7owk7AcCJZjDNE540ZJnsnuqrF0gAACFrKHsejn1sC61jZqIzA
         JpRbm9n1pgby7xjKSepAMoXIU8rSdib8RTdTBkgWzmKimiLbkyCZshbzuAg36sxkAOcC
         Yy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OaXwiorPjTpLFTdpmKT1HPGDgk/XOWSbm8f+u9PPuog=;
        b=dwpy/UqKMA+OSr4FMzwfj9KANIzT/TvhxEYT2CpZxnPp3SBahseI+bIIf6U0ex2/tq
         Dn4a1lgI/xVVYd9NwslAZgzyi3J8uVx/JQJ2Zl5/J51uVlX5E26OeiEPN4WpNEBjfYx9
         Neu2GlmQyvllOIjqmF3QOewTouPOJ5lv+6KxGCzXF8yHQ+HRYk3gxsSNv/u24lX0R/p7
         Mtkht0vxI9Hsclj2M4hWw9vEyV+90xk+hXKh13xMjiR2FruucKOcQcZ8uIO4/X+0j1ZR
         51OwtP4OXaF2L6VzRKMtrCoZtSCqMKE0hadADvZoEvwAkE7Rgc8yCzvhXWzOnj8cOC4U
         CkFg==
X-Gm-Message-State: AOAM530Gzh/34JegeiR4lFhrbshMstphfyFdlsVc8+JV9F8shwDLGC72
        qLW1HdyXe/MVobuJKyTxOqK++VX2mZ+nuQ==
X-Google-Smtp-Source: ABdhPJyi//YltQnL2o6ViqLWhqyjV9whVNLQRuvdrBJ/oIzVG1MlkfCMRtc1veWjIgVBRNKbvxwDRg==
X-Received: by 2002:a62:31c7:0:b029:1b8:4194:8982 with SMTP id x190-20020a6231c70000b02901b841948982mr16126466pfx.33.1611549205386;
        Sun, 24 Jan 2021 20:33:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i132sm8157765pfe.10.2021.01.24.20.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:33:24 -0800 (PST)
Subject: Re: [PATCH liburing v2] tests: add another timeout sequence test case
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20210121181555.110707-1-marcelo827@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27f3c594-9a72-6d06-ae4a-073a5050dd79@kernel.dk>
Date:   Sun, 24 Jan 2021 21:33:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210121181555.110707-1-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/21 11:15 AM, Marcelo Diop-Gonzalez wrote:
> This test case catches an issue where timeouts may not be flushed
> if the number of new events is greater (not equal) to the number
> of events requested in the timeout.

Applied, thanks.

-- 
Jens Axboe

