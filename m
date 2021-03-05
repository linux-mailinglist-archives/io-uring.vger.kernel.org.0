Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10BD32ECD2
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 15:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhCEOM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 09:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhCEOL7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 09:11:59 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE59C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 06:11:58 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id s1so2056113ilh.12
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 06:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eV0NUC8g+KuOS4tN2v/IXyBk5fT57NRotCL7T5XLD3w=;
        b=QzlKLJOKDgu202pq0k+XXm0db3Y54HcxaRqO9kyX7xnK1NKOn5XKvWBZuNrCXL5Z4N
         ywaHP7C8iqOdiXFOdLD5oCXTst1BegPhMzot9WoAjR5HE0s/YoILNCxJk0Hkn/SJ7iWw
         9Rhk2+m4omumjPBvVuxvIcAS9Z05RGOAHxcIvScsDaU1IDcM0KKkJ0AWTJ7FW+msdbJK
         +TuJS4IG27xJF7h7ywXpXav4bv3Udm9O5IXcluGz5t6tKyzP6k3cWjOuCrxi3DZoD7wT
         PkL/Ht8YDNcMwoEqedWVdGXhAQxr1UAxSYa86mj3o+Yb++K5HJNIx5lf4uFKCNlNZcr6
         Jh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eV0NUC8g+KuOS4tN2v/IXyBk5fT57NRotCL7T5XLD3w=;
        b=MBHUZV5yaBSJl8w25RbyCoKqUjwC5N5dEhAcIHA6BmtWKfNLVZVJzdUNzpwTziYSzr
         4oDh2bqucAIRsG25GVcKDpgVrT5awy75JLhp6TKkNuom8Uoie9cATxcWad4oA7LDRbeI
         xgjzSVk3ajNbQrrEfJGLC1PcHnfWQw1FXt7Wwvv/AfUof6DMzM8em3Zl7I4UWS6E4CaK
         FVYHSuyC2siNGwx8MVPd2iDXh75QnwmGMN7WzefdItOBTlpmgWxoyjQSoqgEPqQRcUwz
         yofFY7eb90wtRqPJX6PHxYE4b1kQoTrc2nWD6/FHlAxGWIp2t7yjyjZODlil1ntnpup4
         ax/w==
X-Gm-Message-State: AOAM533+XB2DN+WfzfOnmOf1RfrCqm9+FQuQvfaTdEnJE00nZvE3cb9o
        fUO02qXS9ZyUwt32XMDehc9mxQ==
X-Google-Smtp-Source: ABdhPJwORH1fbIykt6WE/vqOAPa5wrtxEpuybcXAGA6fAnT+VV8xfVaYp3LG1Yo1ZvTEFnuGtDHZfQ==
X-Received: by 2002:a05:6e02:f47:: with SMTP id y7mr8903069ilj.87.1614953518201;
        Fri, 05 Mar 2021 06:11:58 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w2sm1366547ioa.46.2021.03.05.06.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 06:11:57 -0800 (PST)
Subject: Re: [PATCH][next] io_uring: Fix error returns when create_io_thread
 fails
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210305093238.60818-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <22240a85-5920-3d6e-ddb9-f6480ae941de@kernel.dk>
Date:   Fri, 5 Mar 2021 07:11:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210305093238.60818-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/5/21 2:32 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return when create_io_thread calls fail is not using the
> error return code from the returned pointer. Fix this by using
> the error code in PTR_ERR(tsk).

Thanks Colin, I'm going to fold this in.

-- 
Jens Axboe

