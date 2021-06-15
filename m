Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1473A8B2D
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFOViZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFOViZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:38:25 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77552C061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:36:19 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so364693otr.7
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WoaZb8dhb2bmzpMHXF+GfSBa7T+5eoo+tKzEjOfjZRs=;
        b=FGKUiwoWTWm7ytm5PI1pqgnF2y4LcXaoFJbxTRUwe9lficmMGJOUtVht5fqbvjF0lU
         Z9YBhyyGOBWze8CXFsBZxx4+7q8ne8SZrLEVTAYON4Zv04fxCfUzDyexKxuzI/D3HD3L
         qLYpBOQ6M06HRH5JBTq1WmqizjmorVfhX/GgcUBoy8N1htrdY7W4D2HGn3TdiOkhjvdK
         MwBXwEiYxhMh9PD/vlyt2eejCJdxtN3JOz4nmNB2cTS2MTU1UIdnrSE4aSut5LZRXeXF
         jWOF63/L4k9/iISRs5ff7TXhYPAZOFUZ9wgXe/HsX3p9j0FMbNPB7eJtfIUjTzsEuSXZ
         tBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoaZb8dhb2bmzpMHXF+GfSBa7T+5eoo+tKzEjOfjZRs=;
        b=OaZp1DABYknVmnAkAc8lC9s5encMVwgXMa7Ut3j+K9rZUFHVy3Ae/+0F1wLgs86izy
         BpHNKpt7Sg6ISMMH+8myrzWizv8ZRNzuu5wWVArrQAQOez901QwZOeBZllZsrtM2jOGl
         F6rvtLNmtaEvYJ5iNw+jFdGwaQm1qw+2SzC10xSl205TZLNfgTVZh3v9fGYOPE75SEMv
         Oe6MLsASCyl7WZSyPneiDZaHDf1/IPr24yR/au+DGhIq8KD4qze8n2zmxZu/PsWfnRBS
         FMXiQXJkk5P5sS6XSDKEBG+kDRLSR1wGX4N4k5vMXk1HRg7WozAPU3uQzy+uuMNfkm1F
         VznQ==
X-Gm-Message-State: AOAM530WH5JHeNMS6TKhON/4r90zlK2GfeqOF3ZXexi0IkFSbWnqjtQR
        KXB9OsJW4b2+meEgGBcC0HHKAVXVkYMP7w==
X-Google-Smtp-Source: ABdhPJwmSYZNTKQQGuk5Q4WoIoZKzbGLE0J1H7Q0oi9CWDG7658EATqxdSK0qrVBm3YwjLEFddLAyQ==
X-Received: by 2002:a9d:4f0e:: with SMTP id d14mr1033011otl.70.1623792978589;
        Tue, 15 Jun 2021 14:36:18 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 79sm44267otc.34.2021.06.15.14.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:36:17 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] queue: clean up SQ flushing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <7c725dda9dba669235737ee5fd0b37909b6d25a5.1623769611.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <685b75e3-772c-6960-f8f6-eb1ec652c310@kernel.dk>
Date:   Tue, 15 Jun 2021 15:36:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c725dda9dba669235737ee5fd0b37909b6d25a5.1623769611.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 9:07 AM, Pavel Begunkov wrote:
> Clean up and deduplicate parts of __io_uring_flush_sq(), also helping to
> generate a better binary if a compiler is not smart enough.

Applied, thanks.

-- 
Jens Axboe

