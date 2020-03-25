Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938ED191FD3
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2020 04:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCYDsa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Mar 2020 23:48:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43004 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYDsa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Mar 2020 23:48:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id e1so280140plt.9
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2020 20:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CWdyd6j2r7FGt8O9BrZXJ57QRfz1CXItxfCIuK+HcGQ=;
        b=q/LyPn1AoWnQFxjXkHL+8Jyn2wCJxi2NRICYkLYc9ppR+AjmgKVExL4QA7TUmZODx8
         HIg28z2seGLZE4B+yDZ/zWX8HZo82n7SzoPW+4QT8ZPsvZqN4FvOzxJpiiEsZSVlRFMN
         7PrJKFb3ZC/5HNSlcSojWFdcxzA1fAzi60UodxOOu1EwiNub38j47zQ7v6sb6Z8DfNEI
         wv4wZVSh2v9Q8TTjh/7v6v8RDdipvTklOqiadmpFVUAATd0UilLg/AhHoqeIk3B4JFYL
         okDUpFtPz+PCuGXcUYDl+74zzrNcj5Y5AKMiFRLD0vDOJ5/fGsOB70msOG2NoHRMbtN2
         abZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWdyd6j2r7FGt8O9BrZXJ57QRfz1CXItxfCIuK+HcGQ=;
        b=mHYS0GnQHFcIJ5pus4ktwB+oq4JFLQ2kcdqghBUaFTjbZTJDxFKinX06Nwlj5Wn1JD
         ffMCvGo/8rSmznNbZiSgZv/SOlXzIrWzZdweOqhCI5g89QCabqedUNYk9nmyZXJtsoMY
         gTdxOhQAU40axdpvrUfVP0FNK6uFNRe9P+DbzOxl+NkEwKB+usCeFjGKBAWft2ZWy7rR
         GncDRcKmBwaPjae753WZjWpin9d18PO7riGULSdi5+MTmwDyzu6Ix/fJGFux3wRQ4V2i
         OIJyKbQry9ns0FChEYvCRTWeDRLqPaiu6zXk4ET8htXGpxm8wkKkKpFavrCt0jnQI3gx
         FGFw==
X-Gm-Message-State: ANhLgQ2qIvCSirXEGz6SYJ5rpjSJEPKl+Eo7/NHZ/Yl2SGCWoECMqSQV
        TLKsOzuqVvVbQZAjHwWxvzks+g==
X-Google-Smtp-Source: ADFU+vsSQEGJ0EO67Ye7iI8H6ByQmJxZoMFVSEIK9Q4us7O5lWZbGu9+Au+xo0Oc5BoN11s990R5Vg==
X-Received: by 2002:a17:902:7886:: with SMTP id q6mr1281983pll.237.1585108108106;
        Tue, 24 Mar 2020 20:48:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i17sm38674pfo.103.2020.03.24.20.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 20:48:27 -0700 (PDT)
Subject: Re: [PATCH] io_uring:fix missing 'return' in comment
To:     Chucheng Luo <luochucheng@vivo.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
References: <20200325033138.21488-1-luochucheng@vivo.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee9047e5-c18e-4f41-e45a-0c5e963787f8@kernel.dk>
Date:   Tue, 24 Mar 2020 21:48:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325033138.21488-1-luochucheng@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/20 9:31 PM, Chucheng Luo wrote:
> the missing 'return' work may make it hard
> for other developers to understand it.

Thanks, that does read better. Notes for future patches:

- You should capitalize the first letter in the commit message,
  any sentence really.
- Commit messages should use 72-74 chars of line width
- Add a space after 'io_uring:' and title description

I fixed these up and hand applied to for-5.7/io_uring.

-- 
Jens Axboe

