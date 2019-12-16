Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2193121A1F
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 20:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLPTjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 14:39:53 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32900 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfLPTjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 14:39:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id y206so6178813pfb.0
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2019 11:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9OeBKtRsLmBl6NOKklX/MVPVm9L5I1LDvPG3iAqE9s=;
        b=ALIOFBI3bEMIAUXTKkKote2v3zM9qe1aVrzr0tRlt9xp6hxNUSAXldGxeRhW+pIflr
         c5bQMYaTSU2RVjEP8oTeUxiNTU1XZCNn3Kla8P+bsSS64x3zECczUEXNoyMPQK7l0vbM
         4kL5AeX0iUj5SOigJT9ZKXQHGKR4MXolQJ2Pt98IdNT2uxfJl+oeSyY7e1e0767Ga2Jx
         ghosecxY0WSC1U/06ikprx5qof7Cl6mjgzmOLpLgjPqSlez17pMmiH8xgu8JW5tbYtVC
         yVJFGffeJ89gLV3OpDDSFr0sD1qtlRGYPBxXDNSpWPsrA1omrh8JARusYUU2BkzmjjTD
         GU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9OeBKtRsLmBl6NOKklX/MVPVm9L5I1LDvPG3iAqE9s=;
        b=h+Wx+U4jEI4nN7g5mVYMqmlVWQ/LCKjJss79/0E7o3BjrVZO87eGDCPzU1svsy+aTE
         +ryFq+PsbkXF6NEJv0OvDIcQBWjaM6+uh4iXevHldbvzM/eYyQ+z6ClzBY+Ny1MCC4Ww
         lkkEtOAI6AXx0N9XuH16je3YUxlQqrrIh0cBHLyL1VTQ8gaaV1Fp98mLRZNLXpMTz454
         7udLAXdH5wQVWpauIu4e8d02kDnS8lG5GtH60aSb6Etdi/hh3VzvJgrWJPSHYgDTgg5c
         +xDzp61VXQIigLziqZguxJ24dGEMLpv0AbXsy8wh6rrK+qxXKHm5IT8gbuEVNxLvlhiX
         VaFg==
X-Gm-Message-State: APjAAAUlwOFh7am+RJWcO7XY6yj/jjzLuQ+E7LXBjRJMGwi13tcJHwjm
        dQvOykGAWJnCAhoC88DFqOp3DQ==
X-Google-Smtp-Source: APXvYqyGv15kXU7qKns1FeGYP5Jjx9Vw2i9+e3Zl9sufQl+Fuq36ToBn6f9QdN1piio/BnK2KaBO3A==
X-Received: by 2002:a62:a118:: with SMTP id b24mr17977047pff.71.1576525192147;
        Mon, 16 Dec 2019 11:39:52 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1017? ([2620:10d:c090:180::7616])
        by smtp.gmail.com with ESMTPSA id s15sm22298553pgq.4.2019.12.16.11.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 11:39:51 -0800 (PST)
Subject: Re: [PATCH 06/10] fs: move filp_close() outside of
 __close_fd_get_file()
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20191213183632.19441-1-axboe@kernel.dk>
 <20191213183632.19441-7-axboe@kernel.dk>
 <CAG48ez26wpE_K_KGsE8jfjGp3uPc_ioYhTuLv0gSmcVPPxRA3Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c88b3e49-835f-ff79-0a25-da38f2ffc6e1@kernel.dk>
Date:   Mon, 16 Dec 2019 12:39:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAG48ez26wpE_K_KGsE8jfjGp3uPc_ioYhTuLv0gSmcVPPxRA3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/19 12:27 PM, Jann Horn wrote:
> On Fri, Dec 13, 2019 at 7:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>> Just one caller of this, and just use filp_close() there manually.
>> This is important to allow async close/removal of the fd.
> [...]
>> index 3da91a112bab..a250d291c71b 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -662,7 +662,7 @@ int __close_fd_get_file(unsigned int fd, struct file **res)
>>         spin_unlock(&files->file_lock);
>>         get_file(file);
>>         *res = file;
>> -       return filp_close(file, files);
>> +       return 0;
> 
> Above this function is a comment saying "variant of __close_fd that
> gets a ref on the file for later fput"; that should probably be
> changed to point out that you also still need to filp_close().

Good point, I'll make the comment edit.

-- 
Jens Axboe

